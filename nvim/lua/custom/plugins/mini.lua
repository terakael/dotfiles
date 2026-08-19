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

    -- You can configure sections in the statusline by overriding their
    -- default behavior. For example, here we set the section for
    -- cursor location to LINE:COLUMN
    ---@diagnostic disable-next-line: duplicate-set-field
    statusline.section_location = function()
      return '%2l:%-2v'
    end

    -- Override filename section to show Harpoon list status
    ---@diagnostic disable-next-line: duplicate-set-field
    statusline.section_filename = function()
      local success, harpoon = pcall(require, 'harpoon')
      if not success then
        return vim.fn.expand('%:t')
      end

      local list = harpoon:list()
      local current_file = vim.fn.expand('%:f')
      local current_abs = vim.fn.fnamemodify(current_file, ':p')

      local items = {}
      local found_in_list = false

      for index, item in ipairs(list.items) do
        local filename = vim.fn.fnamemodify(item.value, ':t')
        local item_abs = vim.fn.fnamemodify(item.value, ':p')

        if item_abs == current_abs then
          found_in_list = true
          table.insert(items, string.format('%%#MiniStatuslineFilename#[%d: %s]', index, filename))
        else
          table.insert(items, string.format('%d: %s', index, filename))
        end
      end

      -- If current file is not in harpoon list, append it without a number
      if not found_in_list and current_file ~= '' then
        local current_filename = vim.fn.fnamemodify(current_file, ':t')
        table.insert(items, string.format('%%#MiniStatuslineFilename#[%s]', current_filename))
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
