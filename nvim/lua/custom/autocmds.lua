-- Auto-create pyrightconfig.json if .venv exists but pyrightconfig doesn't
vim.api.nvim_create_autocmd({ 'VimEnter', 'DirChanged' }, {
  desc = 'Auto-create pyrightconfig.json for .venv projects',
  group = vim.api.nvim_create_augroup('auto-pyrightconfig', { clear = true }),
  callback = function()
    local cwd = vim.fn.getcwd()
    local venv_path = cwd .. '/.venv'
    local pyright_config = cwd .. '/pyrightconfig.json'

    -- Check if .venv exists and pyrightconfig.json doesn't
    if vim.fn.isdirectory(venv_path) == 1 and vim.fn.filereadable(pyright_config) == 0 then
      local config_content = vim.json.encode({
        venvPath = '.',
        venv = '.venv',
      })
      local file = io.open(pyright_config, 'w')
      if file then
        file:write(config_content)
        file:close()
      end
    end
  end,
})

-- Auto-reload buffers when files change externally
vim.api.nvim_create_autocmd({ 'FocusGained', 'TermClose', 'TermLeave', 'CursorHold', 'CursorHoldI' }, {
  desc = 'Check for file changes and reload buffer if unchanged',
  group = vim.api.nvim_create_augroup('auto-reload', { clear = true }),
  callback = function()
    if vim.o.buftype ~= 'nofile' then
      vim.cmd('checktime')
    end
  end,
})
