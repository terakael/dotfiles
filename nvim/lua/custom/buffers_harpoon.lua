---@class snacks.picker.finder.Item

---Open a snacks picker combining open buffers and the harpoon list.
local M = {}

function M.pick()
  local harpoon_paths = {} ---@type table<string, true>
  local harpoon_items = {} ---@type snacks.picker.finder.Item[]
  local ok, harpoon = pcall(require, 'harpoon')
  if ok then
    for i, item in ipairs(harpoon:list().items) do
      local path = item.value
      if path and path ~= '' then
        local abs = vim.fn.fnamemodify(path, ':p')
        harpoon_paths[abs] = true
        local hbuf = vim.fn.bufadd(path)
        vim.fn.bufload(hbuf)
        table.insert(harpoon_items, {
          idx = i,
          text = path,
          mark = 'H',
          buf = hbuf,
          name = path,
          file = abs,
          filename = vim.fn.fnamemodify(path, ':t'),
          path = abs,
          flags = 'h',
          buftype = '',
          filetype = vim.bo[hbuf].filetype,
        })
      end
    end
  end

  local picker = Snacks.picker
  picker({
    title = 'Buffers + Harpoon',
    format = 'buffer',
    finder = function()
      local items = {} ---@type snacks.picker.finder.Item[]
      local seen = {} ---@type table<string, true>
      for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        if vim.bo[buf].buflisted then
          local name = vim.api.nvim_buf_get_name(buf)
          local full = name ~= '' and vim.fn.fnamemodify(name, ':p') or ''
          local key = full ~= '' and full or '[Scratch]'
          if not seen[key] then
            seen[key] = true
            local display = name ~= '' and name or '[Scratch]'
            local is_h = full ~= '' and harpoon_paths[full] == true
            local info = vim.fn.getbufinfo(buf)[1]
            local mark = vim.api.nvim_buf_get_mark(buf, '"')
            local flags = {
              buf == vim.api.nvim_get_current_buf() and '%' or '',
              (info.hidden == 1) and 'h' or '',
              vim.bo[buf].readonly and '=' or '',
              (info.changed == 1) and '+' or '',
            }
            if is_h then
              flags[2] = 'H'
            end
            table.insert(items, {
              idx = #items + 1,
              text = display,
              buf = buf,
              name = display,
              file = full ~= '' and full or nil,
              filename = vim.fn.fnamemodify(display, ':t'),
              path = full ~= '' and full or display,
              flags = table.concat(flags),
              buftype = vim.bo[buf].buftype,
              filetype = vim.bo[buf].filetype,
              mark = is_h and 'H' or '',
              pos = mark[1] ~= 0 and { mark[1], mark[2] } or nil,
            })
          end
        end
      end
      for _, item in ipairs(harpoon_items) do
        if not seen[item.file] then
          seen[item.file] = true
          item.idx = #items + 1
          table.insert(items, item)
        end
      end
      return items
    end,
    confirm = function(picker, item)
      picker:close()
      if item and item.buf and item.buf ~= 0 and vim.api.nvim_buf_is_valid(item.buf) then
        vim.api.nvim_set_current_buf(item.buf)
      elseif item and item.file and item.file ~= '' then
        vim.cmd('edit ' .. vim.fn.fnameescape(item.file))
      end
    end,
  })
end

return M
