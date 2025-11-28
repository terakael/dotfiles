local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

-- remap leader key
keymap('n', '<Space>', '', opts)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- yank to system clipboard
keymap({ 'n', 'v' }, '<leader>y', '"+y', opts)

-- paste from system clipboard
keymap({ 'n', 'v' }, '<leader>p', '"+p', opts)

-- better indent handling
keymap('v', '<', '<gv', opts)
keymap('v', '>', '>gv', opts)

-- removes highlighting after escping vim search
keymap('n', '<Esc>', '<Esc>:noh<CR>', opts)

-- general keymaps
keymap({ 'n', 'v' }, '<leader>s.', "<cmd>lua require('vscode').action('workbench.action.quickOpen')<CR>")
keymap({ 'n', 'v' }, '<leader>sf', "<cmd>lua require('vscode').action('workbench.action.findInFiles')<CR>")
keymap({ 'n', 'v' }, 'gd', "<cmd>lua require('vscode').action('editor.action.revealDefinition')<CR>")
keymap({ 'n', 'v' }, 'gr', "<cmd>lua require('vscode').action('editor.action.goToReferences')<CR>")
