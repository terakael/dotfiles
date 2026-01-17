return {
  'kristijanhusak/vim-dadbod-ui',
  cmd = { 'DB', 'DBUI', 'DBUIToggle', 'DBUIAddConnection', 'DBUIFindBuffer' },
  dependencies = {
    { 'tpope/vim-dadbod', lazy = true },
    {
      'kristijanhusak/vim-dadbod-completion',
      ft = { 'sql', 'mysql', 'plsql' },
      lazy = true,
    },
    init = function()
      vim.g.db_ui_use_nerd_fonts = 1
    end,
  },
  config = function()
    -- Dadbod configuration
    vim.g.db_ui_use_nerd_fonts = 1
    vim.g.db_ui_show_database_icon = 1
    vim.g.db_ui_force_echo_notifications = 1
    vim.g.db_ui_win_position = 'left'
    vim.g.db_ui_winwidth = 30

    -- Connection configuration
    vim.g.dbs = {
      -- Add your connection string here
      -- dev = 'postgresql://user:password@host:port/database',
    }
  end,
}
