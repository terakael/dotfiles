-- Forest colorscheme color definitions
-- Matches terminal and OpenCode forest theme

local colors = {
  -- Base colors
  bg = '#252321',
  fg = '#d3c6aa',

  -- Normal colors
  black = '#344045',
  red = '#cf6a6d',
  green = '#96ad73',
  yellow = '#c6ab73',
  blue = '#72a9a2',
  magenta = '#c18aa5',
  cyan = '#76ad84',
  white = '#bfb49d',

  -- Bright colors
  bright_black = '#5e6860',
  bright_red = '#a85a5d',
  bright_green = '#78895c',
  bright_yellow = '#9e885a',
  bright_blue = '#5a8580',
  bright_magenta = '#9a6d83',
  bright_cyan = '#5d8a68',
  bright_white = '#998e79',

  -- Additional UI colors
  dark_gray = '#2d2a27',
  code_gray = '#302d2a',
  selection_bg = '#1a1816',
  panel_bg = '#30312e',

  -- Special
  none = 'NONE',
}

-- Semantic color mappings based on OpenCode theme
colors.comment = colors.bright_black
colors.keyword = colors.red
colors.function_name = colors.green
colors.string = colors.cyan
colors.number = colors.magenta
colors.type = colors.yellow
colors.operator = colors.blue
colors.punctuation = colors.fg

-- UI element colors
colors.cursor_line = colors.dark_gray
colors.cursor = colors.fg
colors.visual = colors.selection_bg
colors.search = colors.bright_yellow
colors.match_paren = colors.bright_cyan

-- Status and UI
colors.statusline_bg = colors.panel_bg
colors.statusline_fg = colors.fg
colors.line_nr = colors.bright_black
colors.line_nr_current = colors.yellow

-- Diagnostic colors
colors.error = colors.red
colors.warning = colors.yellow
colors.info = colors.cyan
colors.hint = colors.blue

-- Git colors
colors.git_add = colors.green
colors.git_change = colors.yellow
colors.git_delete = colors.red

-- Diff colors
colors.diff_add = colors.green
colors.diff_delete = colors.red
colors.diff_change = colors.blue
colors.diff_text = colors.cyan

return colors
