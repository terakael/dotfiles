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

    -- Picker keymaps (formerly telescope <leader>s* bindings)
    local picker = Snacks.picker
    vim.keymap.set('n', '<leader>sh', picker.help, { desc = '[S]earch [H]elp' })
    vim.keymap.set('n', '<leader>sk', picker.keymaps, { desc = '[S]earch [K]eymaps' })
    vim.keymap.set('n', '<leader>sf', function()
      picker.files { hidden = true }
    end, { desc = '[S]earch [F]iles' })
    vim.keymap.set('n', '<leader>ss', picker.pickers, { desc = '[S]earch [S]elect Picker' })
    -- vim.keymap.set('n', '<leader>sw', picker.grep_word, { desc = '[S]earch current [W]ord' })
    vim.keymap.set('n', '<leader>sg', picker.grep, { desc = '[S]earch by [G]rep' })
    vim.keymap.set('v', '<leader>sg', function()
      picker.grep_word()
    end, { desc = '[S]earch by [G]rep (selection)' })
    vim.keymap.set('n', '<leader>sd', picker.diagnostics, { desc = '[S]earch [D]iagnostics' })
    vim.keymap.set('n', '<leader>sr', picker.resume, { desc = '[S]earch [R]esume' })
    vim.keymap.set('n', '<leader>s.', picker.recent, { desc = '[S]earch Recent Files ("." for repeat)' })
    vim.keymap.set('n', '<leader>sm', picker.marks, { desc = '[S]earch [M]arks' })
    vim.keymap.set('n', '<leader><leader>', picker.buffers, { desc = '[ ] Find existing buffers' })

    -- Grep only in open buffers
    vim.keymap.set('n', '<leader>s/', function()
      picker.grep { buffers = true, prompt_title = 'Live Grep in Open Files' }
    end, { desc = '[S]earch [/] in Open Files' })

    -- Search within current buffer
    vim.keymap.set('n', '<leader>/', function()
      picker.lines {
        layout = {
          fullscreen = false,
        },
      }
    end, { desc = '[/] Fuzzily search in current buffer' })
    vim.keymap.set('v', '<leader>/', function()
      picker.lines {
        layout = {
          fullscreen = false,
        },
      }
    end, { desc = '[/] Search in current buffer (selection)' })

    -- Shortcut for searching Neovim configuration files
    vim.keymap.set('n', '<leader>sn', function()
      picker.files { cwd = vim.fn.stdpath 'config' }
    end, { desc = '[S]earch [N]eovim files' })

    -- Git pickers (formerly telescope builtin.git_*)
    vim.keymap.set('n', '<leader>gs', function()
      picker.git_status()
    end, { desc = '[G]it [S]tatus' })
    vim.keymap.set('n', '<leader>gc', function()
      picker.git_log()
    end, { desc = '[G]it [C]ommits' })
    vim.keymap.set('n', '<leader>gC', function()
      picker.git_log { current_file = true, follow = true }
    end, { desc = '[G]it Buffer [C]ommits' })
    vim.keymap.set('n', '<leader>gb', function()
      Snacks.gitbrowse()
    end, { desc = '[G]it [B]rowse' })
    vim.keymap.set('n', '<leader>gg', function()
      Snacks.lazygit()
    end, { desc = '[G]it Lazy[g]it' })
    vim.keymap.set('n', '<leader>gl', function()
      Snacks.lazygit.log()
    end, { desc = '[G]it [L]og' })
    vim.keymap.set('n', '<leader>gL', function()
      Snacks.lazygit.log_file()
    end, { desc = '[G]it file [L]og' })
  end,
  opts = {
    animate = { enabled = false },
    indent = { enabled = true },
    lazygit = {},
    input = { enabled = true },
    picker = {
      enabled = true,
      layout = {
        fullscreen = true,
      },
      matcher = {
        frecency = true,
      },
      formatters = {
        file = {
          filename_first = true,
        },
      },
      win = {
        input = {
          keys = {
            ['<c-u>'] = { 'preview_scroll_up', mode = { 'i', 'n' } },
            ['<c-d>'] = { 'preview_scroll_down', mode = { 'i', 'n' } },
          },
        },
      },
    },
    -- Global styles for all Snacks windows
    styles = {
      lazygit = {
        width = 0.98,
        height = 0.98,
      },
    },
  },
}
