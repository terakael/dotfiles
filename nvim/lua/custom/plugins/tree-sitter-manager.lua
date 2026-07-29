return {
  {
    'romus204/tree-sitter-manager.nvim',
    dependencies = {},
    config = function()
      require('tree-sitter-manager').setup {
        auto_install = true, -- Automatically downloads missing language parsers
        highlight = true, -- Uses core Neovim API to toggle highlighting
      }
    end,
  },
}
