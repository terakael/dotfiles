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
    {
      '<C-\\>',
      function()
        Snacks.terminal.toggle()
      end,
      desc = 'Toggle Terminal',
    },
  },
  -- Register the actual keymap once snacks is loaded
  config = function(_, opts)
    require('snacks').setup(opts)
    local toggle = function()
      Snacks.terminal.toggle()
    end
    vim.keymap.set({ 'n', 't' }, '<C-\\>', toggle, { desc = 'Toggle Terminal' })
  end,
  opts = {
    animate = { enabled = true },
    -- scroll = {
    --   enabled = true,
    --   animate = {
    --     duration = { step = 10, total = 100 },
    --     easing = 'linear',
    --   },
    -- },
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
