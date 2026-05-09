return {
  'folke/snacks.nvim',
  priority = 1000,
  lazy = false,
  keys = {
    {
      '<leader>z',
      function()
        Snacks.zen.zoom()
      end,
      desc = 'Zen Zoom',
    },
  },
  opts = {
    animate = { enabled = true },
    scroll = {
      enabled = true,
      animate = {
        duration = { step = 10, total = 100 },
        easing = 'linear',
      },
    },
    indent = { enabled = true },
    lazygit = {},
    input = { enabled = true },
    picker = { enabled = true },
    -- Global styles for all Snacks windows
    styles = {
      lazygit = {
        width = 0.98,
        height = 0.98,
      },
      picker = {
        width = 0.98,
        height = 0.98,
      },
    },
  },
}
