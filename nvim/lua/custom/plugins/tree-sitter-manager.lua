return {
  {
    'romus204/tree-sitter-manager.nvim',
    dependencies = {},
    config = function()
      -- Prepend plugin's runtime path so Neovim finds its queries automatically
      local plugin_path = vim.fn.stdpath 'data' .. '/lazy/tree-sitter-manager.nvim/runtime'
      if vim.fn.isdirectory(plugin_path) == 1 and not vim.tbl_contains(vim.opt.rtp:get(), plugin_path) then
        vim.opt.rtp:prepend(plugin_path)
      end

      require('tree-sitter-manager').setup {
        auto_install = true, -- Automatically downloads missing language parsers
        highlight = true, -- Uses core Neovim API to toggle highlighting
      }
    end,
  },
}
