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

-- Detect Helm template files
vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
  desc = 'Set filetype for Helm template files',
  group = vim.api.nvim_create_augroup('helm-filetype', { clear = true }),
  pattern = { '*/templates/*.yaml', '*/templates/*.tpl', 'helmfile.yaml' },
  callback = function()
    vim.bo.filetype = 'helm'
  end,
})

-- Enhanced Helm syntax highlighting
vim.api.nvim_create_autocmd('FileType', {
  desc = 'Apply enhanced highlighting for Helm templates',
  group = vim.api.nvim_create_augroup('helm-highlights', { clear = true }),
  pattern = 'helm',
  callback = function()
    local colors = require('forest.colors')
    
    -- Highlight template brackets distinctly (like vim-helm's PreProc)
    vim.api.nvim_set_hl(0, '@punctuation.bracket.helm', { fg = colors.red, bold = true })
    vim.api.nvim_set_hl(0, '@punctuation.bracket.gotmpl', { fg = colors.red, bold = true })
    
    -- Helm-specific constants (.Values, .Release, .Chart)
    vim.api.nvim_set_hl(0, '@constant.builtin.helm', { fg = colors.bright_magenta, bold = true })
    vim.api.nvim_set_hl(0, '@constant.builtin.gotmpl', { fg = colors.bright_magenta, bold = true })
    
    -- Template variables and nested properties
    vim.api.nvim_set_hl(0, '@variable.member.helm', { fg = colors.yellow })
    vim.api.nvim_set_hl(0, '@variable.member.gotmpl', { fg = colors.yellow })
    
    -- YAML properties (keys)
    vim.api.nvim_set_hl(0, '@property', { fg = colors.blue, bold = true })
    vim.api.nvim_set_hl(0, '@string.yaml', { fg = colors.cyan })
    
    -- Sprig/template functions
    vim.api.nvim_set_hl(0, '@function.builtin.helm', { fg = colors.green, bold = true })
    vim.api.nvim_set_hl(0, '@function.builtin.gotmpl', { fg = colors.green, bold = true })
  end,
})

-- Enable line wrapping for markdown and text files
vim.api.nvim_create_autocmd('FileType', {
  desc = 'Enable line wrapping for document files',
  group = vim.api.nvim_create_augroup('wrap-documents', { clear = true }),
  pattern = { 'markdown', 'text' },
  callback = function()
    vim.opt_local.wrap = true
  end,
})
