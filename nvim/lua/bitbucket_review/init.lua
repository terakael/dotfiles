-- Bitbucket PR Review plugin entry point
local M = {}
local pr = require('bitbucket_review.pr')
local gutter = require('bitbucket_review.gutter')
local ui = require('bitbucket_review.ui')

local loaded = false
local loading = false

-- Load PR + comments for the current repo. Idempotent.
-- force: re-fetch even if already loaded
-- callback: optional function() called on success
function M.load(force, callback)
  if loaded and not force then
    if callback then callback() end
    return
  end
  if loading then return end
  loading = true

  pr.detect(function(err, found_pr)
    if err then
      vim.notify('[BbReview] ' .. err, vim.log.levels.WARN)
      loading = false
      return
    end
    if not found_pr then
      loading = false
      return
    end

    local title = found_pr.title or ''
    local from = (found_pr.fromRef or {}).displayId or '?'
    local to = (found_pr.toRef or {}).displayId or '?'
    vim.notify(('[BbReview] PR #%d bound: %s → %s'):format(found_pr.id, from, to), vim.log.levels.INFO)

    pr.fetch_comments(function(cerr, _)
      loading = false
      if cerr then
        vim.notify('[BbReview] Failed to fetch comments: ' .. cerr, vim.log.levels.WARN)
        return
      end
      loaded = true
      for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
        if vim.api.nvim_buf_is_loaded(bufnr) then
          gutter.refresh(bufnr)
        end
      end
      if callback then callback() end
    end)
  end)
end

-- Main action: open comment thread / post new comment on current line
local function open_comment()
  local bufnr = vim.api.nvim_get_current_buf()
  local line = vim.api.nvim_win_get_cursor(0)[1]
  local file_path = pr.relative_path(bufnr)
  if not file_path then
    vim.notify('[BbReview] Buffer is not inside a git repo', vim.log.levels.WARN)
    return
  end

  local function do_open()
    local threads = pr.get_threads(file_path, line)

    local function do_reply(parent_id)
      local title = parent_id and 'Reply' or ('Comment on line ' .. line)
      ui.open_input(title, function(text)
        if parent_id then
          pr.post_reply(parent_id, text, function(cerr, _)
            if cerr then
              vim.notify('[BbReview] Reply failed: ' .. cerr, vim.log.levels.ERROR)
            else
              vim.notify('[BbReview] Reply posted.', vim.log.levels.INFO)
              gutter.refresh(bufnr)
            end
          end)
        else
          pr.post_comment(file_path, line, text, function(cerr, _)
            if cerr then
              vim.notify('[BbReview] Comment failed: ' .. cerr, vim.log.levels.ERROR)
            else
              vim.notify('[BbReview] Comment posted.', vim.log.levels.INFO)
              gutter.refresh(bufnr)
            end
          end)
        end
      end)
    end

    if #threads > 0 then
      ui.open_thread(threads, do_reply)
    else
      do_reply(nil)
    end
  end

  if not loaded then
    M.load(false, function()
      if not pr.state.pr then
        vim.notify('[BbReview] No open PR for this branch.', vim.log.levels.INFO)
        return
      end
      do_open()
    end)
  else
    if not pr.state.pr then
      vim.notify('[BbReview] No open PR for this branch.', vim.log.levels.INFO)
      return
    end
    do_open()
  end
end

function M.setup()
  vim.keymap.set('n', '<leader>cc', open_comment, { desc = 'PR [C]omment on line' })

  vim.keymap.set('n', '<leader>cr', function()
    loaded = false
    M.load(true)
  end, { desc = 'PR [C]omments [R]efresh' })

  vim.keymap.set('n', '<leader>ci', function()
    if pr.state.pr then
      local p = pr.state.pr
      local from = (p.fromRef or {}).displayId or '?'
      local to = (p.toRef or {}).displayId or '?'
      vim.notify(('[BbReview] PR #%d: %s\n  %s → %s'):format(p.id, p.title or '', from, to), vim.log.levels.INFO)
    else
      vim.notify('[BbReview] No PR bound for this branch.', vim.log.levels.INFO)
    end
  end, { desc = 'PR [C]omments [I]nfo' })

  vim.keymap.set('n', '<leader>cd', function()
    if not pr.state.pr then
      vim.notify('[BbReview] No PR bound', vim.log.levels.WARN)
      return
    end
    local api = require('bitbucket_review.api')
    local url = ('%s/rest/api/1.0/projects/%s/repos/%s/pull-requests/%d/activities?limit=10')
      :format(pr.state.base_url, pr.state.project, pr.state.repo, pr.state.pr.id)
    api.get(url, function(err, data)
      if err then
        vim.notify('[BbReview] Debug fetch error: ' .. err, vim.log.levels.ERROR)
        return
      end
      local lines = { '[BbReview] Raw activities (first 10):' }
      for i, act in ipairs(data.values or {}) do
        local action = tostring(act.action)
        local c = act.comment
        if c then
          local a = c.anchor
          local path_val = a and (type(a.path) == 'table' and vim.inspect(a.path) or tostring(a.path or '(nil)')) or '(no anchor)'
          local line_val = a and tostring(a.line or '(nil)') or '(no anchor)'
          local has_parent = c.parent and tostring(c.parent.id) or 'none'
          table.insert(lines, string.format('  [%d] action=%s  anchor.path=%s  anchor.line=%s  parent=%s', i, action, path_val, line_val, has_parent))
        else
          table.insert(lines, string.format('  [%d] action=%s  (no comment)', i, action))
        end
      end
      local buf_path = pr.relative_path(0)
      table.insert(lines, 'Buffer relative path: ' .. (buf_path or '(nil)'))
      table.insert(lines, 'Indexed paths: ' .. vim.inspect(vim.tbl_keys(pr.state.by_file_line)))
      vim.notify(table.concat(lines, '\n'), vim.log.levels.INFO)
    end)
  end, { desc = 'PR [C]omments [D]ebug' })

  -- Auto-load on first BufEnter; refresh gutter when returning to a buffer
  local group = vim.api.nvim_create_augroup('BbReview', { clear = true })
  vim.api.nvim_create_autocmd('BufEnter', {
    group = group,
    callback = function(ev)
      if not loaded and not loading then
        M.load(false)
      else
        gutter.refresh(ev.buf)
      end
    end,
  })
end

return M
