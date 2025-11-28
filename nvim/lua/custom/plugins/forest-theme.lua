-- Forest colorscheme plugin configuration
-- Custom theme matching terminal and OpenCode forest theme

return {
  dir = vim.fn.stdpath('config') .. '/lua/forest',
  name = 'forest',
  lazy = false,
  priority = 1000,
  config = function()
    require('forest.theme').setup()
  end,
}
