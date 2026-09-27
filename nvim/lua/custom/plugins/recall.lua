return {
  'fnune/recall.nvim',
  event = 'VeryLazy',
  config = function()
    local recall = require 'recall'

    recall.setup {}

    vim.keymap.set('n', '<leader>mm', recall.toggle, { noremap = true, silent = true, desc = 'Recall: toggle mark' })
    vim.keymap.set('n', '<leader>mn', recall.goto_next, { noremap = true, silent = true, desc = 'Recall: next mark' })
    vim.keymap.set('n', '<leader>mp', recall.goto_prev, { noremap = true, silent = true, desc = 'Recall: previous mark' })
    vim.keymap.set('n', '<leader>mc', recall.clear, { noremap = true, silent = true, desc = 'Recall: clear all marks' })
    vim.keymap.set('n', '<leader>sM', require('recall.snacks').pick, { noremap = true, silent = true, desc = 'Recall: list marks' })
  end,
}
