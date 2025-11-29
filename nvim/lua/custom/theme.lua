-- Machine-specific theme configuration
-- This file loads the theme from Omarchy config if available, with a fallback to everforest

local function get_omarchy_theme()
  local omarchy_theme_file = vim.fn.expand '~/.config/omarchy/current/theme/neovim.lua'
  if vim.fn.filereadable(omarchy_theme_file) == 1 then
    local ok, theme_config = pcall(dofile, omarchy_theme_file)
    if ok and theme_config and type(theme_config) == 'table' then
      local theme_plugin = theme_config[1]
      if theme_plugin then
        -- Extract colorscheme name from LazyVim opts
        local colorscheme_name = nil
        for _, entry in ipairs(theme_config) do
          if type(entry) == 'table' and entry.opts and entry.opts.colorscheme then
            colorscheme_name = entry.opts.colorscheme
            break
          end
        end

        if colorscheme_name then
          theme_plugin.priority = 1000
          theme_plugin.init = function()
            vim.cmd.colorscheme(colorscheme_name)
            vim.cmd.hi 'Comment gui=none'
          end
        end

        return theme_plugin
      end
    end
  end

  -- Fallback to everforest if Omarchy theme not available
  return {
    'neanias/everforest-nvim',
    priority = 1000,
    init = function()
      vim.cmd.colorscheme 'everforest'
      vim.cmd.hi 'Comment gui=none'
    end,
  }
end

return get_omarchy_theme()
