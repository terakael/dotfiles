-- PR detection and comment state management
local M = {}
local api = require('bitbucket_review.api')

M.state = {
  pr = nil,
  base_url = nil,
  project = nil,
  repo = nil,
  branch = nil,
  -- [file_path][line_num] = list of top-level comment objects (each may have .comments[] replies)
  by_file_line = {},
}

-- Run a command synchronously, return trimmed stdout or nil
local function cmd(args)
  local r = vim.system(args, { text = true }):wait()
  if r.code ~= 0 then return nil end
  return vim.trim(r.stdout)
end

-- Parse Bitbucket Server remote URL into (base_url, project, repo)
-- Handles:
--   https://host/scm/PROJECT/repo.git
--   ssh://git@host:7999/PROJECT/repo.git
local function parse_remote(url)
  -- HTTPS
  local base, proj, repo = url:match('(https?://[^/]+)/scm/([^/]+)/([^/.]+)')
  if base then return base, proj:upper(), repo end
  -- SSH  ssh://git@host:port/PROJECT/REPO.git
  base, proj, repo = url:match('ssh://[^@]+@([^:/]+)[:/]%d*/([^/]+)/([^/.]+)')
  if base then return 'https://' .. base, proj:upper(), repo end
  -- SCP  git@host:PROJECT/REPO.git
  base, proj, repo = url:match('[^@]+@([^:]+):([^/]+)/([^/.]+)')
  if base then return 'https://' .. base, proj:upper(), repo end
  return nil, nil, nil
end

-- Recursively flatten a comment thread into a list, tagging each with _depth
local function flatten(comment, depth, out)
  out = out or {}
  depth = depth or 0
  comment._depth = depth
  table.insert(out, comment)
  for _, reply in ipairs(comment.comments or {}) do
    flatten(reply, depth + 1, out)
  end
  return out
end

-- Build by_file_line index from a flat list of top-level comment objects
local function index(comments)
  local idx = {}
  for _, c in ipairs(comments) do
    local a = c.anchor
    if a and a.line and a.path then
      idx[a.path] = idx[a.path] or {}
      idx[a.path][a.line] = idx[a.path][a.line] or {}
      table.insert(idx[a.path][a.line], c)
    end
  end
  return idx
end

-- Returns git root for cwd (sync)
function M.git_root()
  return cmd({ 'git', 'rev-parse', '--show-toplevel' })
end

-- Returns repo-relative path of bufnr (or current buffer)
function M.relative_path(bufnr)
  local abs = vim.api.nvim_buf_get_name(bufnr or 0)
  local root = M.git_root()
  if not root or abs == '' then return nil end
  if abs:sub(1, #root) == root then
    return abs:sub(#root + 2)
  end
  return nil
end

-- Detect PR for the current worktree. callback(err, pr_or_nil)
function M.detect(callback)
  local branch = cmd({ 'git', 'branch', '--show-current' })
  if not branch then
    callback('not in a git repo', nil)
    return
  end
  if branch == 'development' or branch == 'master' or branch == 'main' then
    callback(nil, nil)
    return
  end
  local remote_url = cmd({ 'git', 'remote', 'get-url', 'origin' })
  if not remote_url then
    callback('no git remote origin', nil)
    return
  end
  local base_url, project, repo = parse_remote(remote_url)
  if not base_url then
    callback('could not parse remote: ' .. remote_url, nil)
    return
  end
  M.state.base_url = base_url
  M.state.project = project
  M.state.repo = repo
  M.state.branch = branch

  local url = ('%s/rest/api/1.0/projects/%s/repos/%s/pull-requests?at=refs/heads/%s&state=OPEN&direction=OUTGOING')
    :format(base_url, project, repo, api.urlencode(branch))
  api.get(url, function(err, data)
    if err then callback(err, nil); return end
    local prs = (data or {}).values or {}
    if #prs == 0 then callback(nil, nil); return end
    M.state.pr = prs[1]
    callback(nil, M.state.pr)
  end)
end

-- Fetch all inline PR comments via the activities endpoint and refresh the index.
-- The /comments endpoint requires a ?path= filter; activities gives us everything.
-- callback(err, inline_comments)
function M.fetch_comments(callback)
  local pr = M.state.pr
  if not pr then callback('no PR bound', nil); return end
  local url = ('%s/rest/api/1.0/projects/%s/repos/%s/pull-requests/%d/activities')
    :format(M.state.base_url, M.state.project, M.state.repo, pr.id)
  api.get_all(url, function(err, activities)
    if err then callback(err, nil); return end
    -- Extract top-level inline comments from COMMENTED activities.
    -- The anchor lives at act.commentAnchor (activity level), not act.comment.anchor.
    -- General PR comments have no commentAnchor; skip those.
    local inline = {}
    for _, act in ipairs(activities) do
      if act.action == 'COMMENTED' then
        local anchor = act.commentAnchor
        local c = act.comment
        if c and anchor and anchor.line and anchor.path and not c.parent then
          c.anchor = anchor  -- attach for indexing and posting replies
          table.insert(inline, c)
        end
      end
    end
    M.state.by_file_line = index(inline)
    callback(nil, inline)
  end)
end

-- Returns list of flattened thread lists for a given file + 1-indexed line
-- Each element is a list of comments (top-level + replies, depth-tagged)
function M.get_threads(file_path, line)
  local by_line = M.state.by_file_line[file_path]
  if not by_line then return {} end
  local threads = {}
  for _, top in ipairs(by_line[line] or {}) do
    table.insert(threads, flatten(top))
  end
  return threads
end

-- Detect whether a line is ADDED or CONTEXT relative to development
-- callback(line_type_string)
local function detect_line_type(file_path, line_num, callback)
  vim.system({ 'git', 'diff', 'development..HEAD', '--', file_path }, { text = true }, function(r)
    vim.schedule(function()
      if r.code ~= 0 or not r.stdout or r.stdout == '' then
        callback('ADDED')
        return
      end
      local to_line = 0
      local found = 'CONTEXT'
      for _, dline in ipairs(vim.split(r.stdout, '\n')) do
        local ns, _ = dline:match('^@@ %-%d+,?%d* %+(%d+),?(%d*) @@')
        if ns then
          to_line = tonumber(ns) - 1
        elseif dline:match('^%+') and not dline:match('^%+%+%+') then
          to_line = to_line + 1
          if to_line == line_num then found = 'ADDED'; break end
        elseif dline:match('^%-') and not dline:match('^%-%-%-') then
          -- removed line: does not advance to-side counter
        elseif not dline:match('^\\') and dline ~= '' then
          to_line = to_line + 1
          if to_line == line_num then found = 'CONTEXT'; break end
        end
      end
      callback(found)
    end)
  end)
end

-- Post a new inline comment. callback(err, comment)
function M.post_comment(file_path, line, text, callback)
  local pr = M.state.pr
  if not pr then callback('no PR bound', nil); return end
  local url = ('%s/rest/api/1.0/projects/%s/repos/%s/pull-requests/%d/comments')
    :format(M.state.base_url, M.state.project, M.state.repo, pr.id)

  local function do_post(line_type)
    local body = {
      text = text,
      anchor = {
        diffType = 'EFFECTIVE',
        fileType = 'TO',
        line = line,
        lineType = line_type,
        path = file_path,
      },
    }
    api.post(url, body, function(err, comment)
      if err and line_type == 'ADDED' then
        -- Retry as CONTEXT (line may be unchanged relative to base)
        do_post('CONTEXT')
      elseif err then
        callback(err, nil)
      else
        M.fetch_comments(function() end)
        callback(nil, comment)
      end
    end)
  end

  detect_line_type(file_path, line, do_post)
end

-- Post a reply to an existing comment. callback(err, comment)
function M.post_reply(parent_id, text, callback)
  local pr = M.state.pr
  if not pr then callback('no PR bound', nil); return end
  local url = ('%s/rest/api/1.0/projects/%s/repos/%s/pull-requests/%d/comments')
    :format(M.state.base_url, M.state.project, M.state.repo, pr.id)
  api.post(url, { text = text, parent = { id = parent_id } }, function(err, comment)
    if err then callback(err, nil); return end
    M.fetch_comments(function() end)
    callback(nil, comment)
  end)
end

return M
