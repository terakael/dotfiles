return { -- Collection of various small independent plugins/modules
  'echasnovski/mini.nvim',
  config = function()
    -- Better Around/Inside textobjects
    --
    -- Examples:
    --  - va)  - [V]isually select [A]round [)]paren
    --  - yinq - [Y]ank [I]nside [N]ext [Q]uote
    --  - ci'  - [C]hange [I]nside [']quote
    require('mini.ai').setup { n_lines = 500 }

    -- Add/delete/replace surroundings (brackets, quotes, etc.)
    --
    -- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
    -- - sd'   - [S]urround [D]elete [']quotes
    -- - sr)'  - [S]urround [R]eplace [)] [']
    require('mini.surround').setup()

    -- Simple and easy statusline.
    --  You could remove this setup call if you don't like it,
    --  and try some other statusline plugin
    local statusline = require 'mini.statusline'
    -- set use_icons to true if you have a Nerd Font
    statusline.setup { use_icons = vim.g.have_nerd_font }

    -- Remove filetype from fileinfo section
    ---@diagnostic disable-next-line: duplicate-set-field
    statusline.section_fileinfo = function(args)
      if statusline.is_truncated(args.trunc_width) or vim.bo.buftype ~= '' then
        return ''
      end
      local encoding = vim.bo.fileencoding or vim.bo.encoding
      local format = vim.bo.fileformat
      local size = statusline.get_filesize and statusline.get_filesize() or ''
      return string.format('%s[%s] %s', encoding, format, size)
    end

    -- You can configure sections in the statusline by overriding their
    -- default behavior. For example, here we set the section for
    -- cursor location to LINE:COLUMN
    ---@diagnostic disable-next-line: duplicate-set-field
    statusline.section_location = function()
      return '%2l:%-2v'
    end

    -- Customize active content to place harpoon/filename on the right
    ---@diagnostic disable-next-line: duplicate-set-field
    statusline.active = function()
      local mode, mode_hl = statusline.section_mode { trunc_width = 120 }
      local git = statusline.section_git { trunc_width = 40 }
      local diff = statusline.section_diff { trunc_width = 75 }
      local diagnostics = statusline.section_diagnostics { trunc_width = 75 }
      local lsp = statusline.section_lsp { trunc_width = 75 }
      local filename = statusline.section_filename { trunc_width = 140 }
      local fileinfo = statusline.section_fileinfo { trunc_width = 120 }
      local location = statusline.section_location { trunc_width = 75 }
      local search = statusline.section_searchcount { trunc_width = 75 }

      return statusline.combine_groups {
        { hl = mode_hl, strings = { mode } },
        { hl = 'MiniStatuslineDevinfo', strings = { git, diff, diagnostics, lsp } },
        '%<', -- Mark general truncate point
        '%=', -- Right-align everything after this point
        { hl = 'MiniStatuslineFilename', strings = { filename } },
        { hl = 'MiniStatuslineFileinfo', strings = { fileinfo } },
        { hl = mode_hl, strings = { search, location } },
      }
    end

    -- Link CustomHarpoonActive to mode_hl (same as search/location highlight)
    -- or we can link it directly to a theme group like 'Visual' or 'PmenuSel'
    vim.api.nvim_set_hl(0, 'CustomHarpoonActive', { link = 'MiniStatuslineFileinfo' })

    -- Override filename section to show Harpoon list status
    ---@diagnostic disable-next-line: duplicate-set-field
    statusline.section_filename = function()
      local success, harpoon = pcall(require, 'harpoon')
      if not success then
        return vim.fn.expand '%:t'
      end

      local list = harpoon:list()
      local current_file = vim.fn.expand '%:f'
      local current_abs = vim.fn.fnamemodify(current_file, ':p')

      local items = {}
      local found_in_list = false

      for index, item in ipairs(list.items) do
        local filename = vim.fn.fnamemodify(item.value, ':t')
        local item_abs = vim.fn.fnamemodify(item.value, ':p')

        local modified_mark = ''
        local bufnr = vim.fn.bufnr(item.value)
        if bufnr ~= -1 and vim.bo[bufnr].modified then
          modified_mark = '*'
        end

        if item_abs == current_abs then
          found_in_list = true
          if vim.bo.modified then
            modified_mark = '*'
          end
          table.insert(items, string.format('%%#CustomHarpoonActive#%d %s%s%%#MiniStatuslineFilename#', index, filename, modified_mark))
        else
          table.insert(items, string.format('%d %s%s', index, filename, modified_mark))
        end
      end

      -- If current file is not in harpoon list, append it without a number
      if not found_in_list and current_file ~= '' then
        local current_filename = vim.fn.fnamemodify(current_file, ':t')
        local modified_mark = vim.bo.modified and '*' or ''
        table.insert(items, string.format('%%#CustomHarpoonActive#%s%s%%#MiniStatuslineFilename#', current_filename, modified_mark))
      end

      if #items == 0 then
        return 'No harpoon files'
      end

      return table.concat(items, '  ')
    end

    -- ... and there is more!
    --  Check out: https://github.com/echasnovski/mini.nvim
  end,
}
