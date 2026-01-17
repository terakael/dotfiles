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
  },
  config = function()
    vim.g.db_ui_use_nerd_fonts = 1
    vim.g.db_ui_show_database_icon = 0
    vim.g.db_ui_force_echo_notifications = 0
    vim.g.db_ui_win_position = 'left'
    vim.g.db_ui_winwidth = 30
  end,
}
