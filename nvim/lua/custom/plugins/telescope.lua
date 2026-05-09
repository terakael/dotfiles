return { -- Fuzzy Finder (files, lsp, etc)
  'nvim-telescope/telescope.nvim',
  event = 'VimEnter',
  dependencies = {
    'nvim-lua/plenary.nvim',
    { -- If encountering errors, see telescope-fzf-native README for installation instructions
      'nvim-telescope/telescope-fzf-native.nvim',

      -- `build` is used to run some command when the plugin is installed/updated.
      -- This is only run then, not every time Neovim starts up.
      build = 'make',

      -- `cond` is a condition used to determine whether this plugin should be
      -- installed and loaded.
      cond = function()
        return vim.fn.executable 'make' == 1
      end,
    },
    { 'nvim-telescope/telescope-ui-select.nvim' },

    -- Useful for getting pretty icons, but requires a Nerd Font.
    { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
    { 'jonarrien/telescope-cmdline.nvim' },
  },
  config = function()
    -- Telescope is a fuzzy finder that comes with a lot of different things that
    -- it can fuzzy find! It's more than just a "file finder", it can search
    -- many different aspects of Neovim, your workspace, LSP, and more!
    --
    -- The easiest way to use Telescope, is to start by doing something like:
    --  :Telescope help_tags
    --
    -- After running this command, a window will open up and you're able to
    -- type in the prompt window. You'll see a list of `help_tags` options and
    -- a corresponding preview of the help.
    --
    -- Two important keymaps to use while in Telescope are:
    --  - Insert mode: <c-/>
    --  - Normal mode: ?
    --
    -- This opens a window that shows you all of the keymaps for the current
    -- Telescope picker. This is really useful to discover what Telescope can
    -- do as well as how to actually do it!

    -- [[ Configure Telescope ]]
    -- See `:help telescope` and `:help telescope.setup()`
    require('telescope').setup {
      -- You can put your default mappings / updates / etc. in here
      --  All the info you're looking for is in `:help telescope.setup()`
      --
      -- defaults = {
      --   mappings = {
      --     i = { ['<c-enter>'] = 'to_fuzzy_refine' },
      --   },
      -- },
      pickers = {
        buffers = {
          mappings = {
            n = {
              ['d'] = require('telescope.actions').delete_buffer,
            },
          },
        },
        marks = {
          mappings = {
            n = {
              ['d'] = function(prompt_bufnr)
                local actions = require 'telescope.actions'
                local action_state = require 'telescope.actions.state'
                local selection = action_state.get_selected_entry()
                if selection then
                  -- Extract just the mark character (first field in display)
                  local mark = selection.mark
                  if mark and mark:match '^[a-zA-Z]$' then
                    vim.cmd('delmarks ' .. mark)
                    actions.close(prompt_bufnr)
                    -- Reopen marks picker to show updated list
                    vim.schedule(function()
                      require('telescope.builtin').marks { mark_type = 'local' }
                    end)
                  end
                end
              end,
            },
          },
        },
        lsp_document_symbols = {
          -- theme = 'dropdown',
          symbols = nil,
          ignore_symbols = nil,
          symbol_width = 60, -- Width of the symbol name column (default: 25)
          symbol_type_width = 12, -- Width of the symbol type column (default: auto)
        },
        git_commits = {
          git_command = { 'git', 'log', '--pretty=%h %ad %an %s', '--date=short', '--', '.' },
        },
        git_bcommits = {
          git_command = { 'git', 'log', '--pretty=%h %ad %an %s', '--date=short' },
        },
      },
      defaults = {
        layout_config = {
          horizontal = {
            width = 0.98,
            height = 0.98,
            preview_width = 0.5,
          },
          vertical = {
            width = 0.98,
            height = 0.98,
            preview_height = 0.5,
          },
        },
        file_ignore_patterns = {
          '^%.venv/',
          '/__pycache__/',
          '/%.mypy_cache/',
          '^%.git/',
        },
      },
      extensions = {
        ['ui-select'] = {
          require('telescope.themes').get_dropdown(),
        },
        cmdline = {
          mappings = {
            run_input = '<CR>',
            run_selection = '<S-CR>',
          },
        },
      },
    }

    -- Enable Telescope extensions if they are installed
    pcall(require('telescope').load_extension, 'fzf')
    pcall(require('telescope').load_extension, 'ui-select')
    pcall(require('telescope').load_extension, 'cmdline')

    -- See `:help telescope.builtin`
    local builtin = require 'telescope.builtin'
    vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
    vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
    vim.keymap.set('n', '<leader>sf', function()
      builtin.find_files { hidden = true }
    end, { desc = '[S]earch [F]iles' })
    vim.keymap.set('n', '<leader>ss', builtin.builtin, { desc = '[S]earch [S]elect Telescope' })
    vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
    vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
    -- Visual mode: grep for selected text across project
    vim.keymap.set('v', '<leader>sg', function()
      -- Get the visually selected text
      local visual_selection = vim.fn.getregion(vim.fn.getpos 'v', vim.fn.getpos '.')
      -- Use only the first line for multiline selections
      local search_term = visual_selection[1] or ''

      -- Open grep with the selected text, allowing editing before search
      builtin.grep_string { search = search_term }
    end, { desc = '[S]earch by [G]rep (selection)' })
    vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
    vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
    vim.keymap.set('n', '<leader>s.', builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
    vim.keymap.set('n', '<leader>sm', builtin.marks, { desc = '[S]earch [M]arks' })
    vim.keymap.set('n', '<leader>gs', function()
      builtin.git_status { git_icons = { changed = 'M', added = 'A', deleted = 'D', renamed = 'R', untracked = '?' } }
    end, { desc = '[G]it [S]tatus' })
    vim.keymap.set('n', '<leader>gb', function()
      require('snacks').gitbrowse()
    end, { desc = '[G]it [B]rowse' })
    vim.keymap.set('n', '<leader>gc', builtin.git_commits, { desc = '[G]it [C]ommits' })
    vim.keymap.set('n', '<leader>gC', builtin.git_bcommits, { desc = '[G]it Buffer [C]ommits' })
    vim.keymap.set('n', '<leader>gg', function()
      require('snacks').lazygit()
    end, { desc = '[G]it Lazy[g]it' })
    vim.keymap.set('n', '<leader>gl', function()
      require('snacks').lazygit.log()
    end, { desc = '[G]it [L]og' })
    vim.keymap.set('n', '<leader>gL', function()
      require('snacks').lazygit.log_file()
    end, { desc = '[G]it file [L]og' })
    vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = '[ ] Find existing buffers' })

    -- Slightly advanced example of overriding default behavior and theme
    vim.keymap.set('n', '<leader>/', function()
      -- You can pass additional configuration to Telescope to change the theme, layout, etc.
      builtin.current_buffer_fuzzy_find()
    end, { desc = '[/] Fuzzily search in current buffer' })
    -- Visual mode: search for selected text in current buffer
    vim.keymap.set('v', '<leader>/', function()
      -- Get the visually selected text
      local visual_selection = vim.fn.getregion(vim.fn.getpos 'v', vim.fn.getpos '.')
      -- Use only the first line for multiline selections
      local search_term = visual_selection[1] or ''

      -- Search in current buffer with the selected text
      builtin.current_buffer_fuzzy_find { default_text = search_term }
    end, { desc = '[/] Search in current buffer (selection)' })

    -- It's also possible to pass additional configuration options.
    --  See `:help telescope.builtin.live_grep()` for information about particular keys
    vim.keymap.set('n', '<leader>s/', function()
      builtin.live_grep {
        grep_open_files = true,
        prompt_title = 'Live Grep in Open Files',
      }
    end, { desc = '[S]earch [/] in Open Files' })

    -- Shortcut for searching your Neovim configuration files
    vim.keymap.set('n', '<leader>sn', function()
      builtin.find_files { cwd = vim.fn.stdpath 'config' }
    end, { desc = '[S]earch [N]eovim files' })

    vim.keymap.set('n', ':', function()
      vim.cmd 'Telescope cmdline'
    end, { desc = 'cmdline' })
  end,
}
