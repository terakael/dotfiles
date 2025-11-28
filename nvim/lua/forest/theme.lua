-- Forest colorscheme theme application
-- Sets all highlight groups using forest colors

local M = {}

function M.setup()
  local colors = require('forest.colors')

  -- Clear existing highlights
  vim.cmd('highlight clear')
  if vim.fn.exists('syntax_on') then
    vim.cmd('syntax reset')
  end

  vim.o.termguicolors = true
  vim.g.colors_name = 'forest'

  -- Helper function to set highlights
  local function hl(group, opts)
    vim.api.nvim_set_hl(0, group, opts)
  end

  -- Editor UI
  hl('Normal', { fg = colors.fg, bg = colors.bg })
  hl('NormalFloat', { fg = colors.fg, bg = colors.panel_bg })
  hl('FloatBorder', { fg = colors.bright_black, bg = colors.panel_bg })
  hl('ColorColumn', { bg = colors.dark_gray })
  hl('Conceal', { fg = colors.bright_black })
  hl('Cursor', { fg = colors.bg, bg = colors.cursor })
  hl('CursorLine', { bg = colors.cursor_line })
  hl('CursorColumn', { bg = colors.cursor_line })
  hl('CursorLineNr', { fg = colors.line_nr_current, bold = true })
  hl('LineNr', { fg = colors.line_nr })
  hl('SignColumn', { fg = colors.bright_black, bg = colors.bg })
  hl('Folded', { fg = colors.bright_black, bg = colors.dark_gray })
  hl('FoldColumn', { fg = colors.bright_black, bg = colors.bg })
  hl('VertSplit', { fg = colors.bright_black, bg = colors.bg })
  hl('WinSeparator', { fg = colors.bright_black, bg = colors.bg })
  
  -- Search and Selection
  hl('Visual', { bg = colors.visual })
  hl('VisualNOS', { bg = colors.visual })
  hl('Search', { fg = colors.bg, bg = colors.search })
  hl('IncSearch', { fg = colors.bg, bg = colors.bright_yellow })
  hl('CurSearch', { fg = colors.bg, bg = colors.bright_yellow })
  hl('MatchParen', { fg = colors.match_paren, bold = true, underline = true })
  
  -- Statusline and Tabline
  hl('StatusLine', { fg = colors.statusline_fg, bg = colors.statusline_bg })
  hl('StatusLineNC', { fg = colors.bright_black, bg = colors.dark_gray })
  hl('TabLine', { fg = colors.bright_black, bg = colors.dark_gray })
  hl('TabLineFill', { bg = colors.dark_gray })
  hl('TabLineSel', { fg = colors.fg, bg = colors.bg })
  
  -- Popup Menu (completion)
  hl('Pmenu', { fg = colors.fg, bg = colors.panel_bg })
  hl('PmenuSel', { fg = colors.bg, bg = colors.cyan })
  hl('PmenuSbar', { bg = colors.dark_gray })
  hl('PmenuThumb', { bg = colors.bright_black })
  hl('WildMenu', { fg = colors.bg, bg = colors.cyan })
  
  -- Messages and Command Line
  hl('MsgArea', { fg = colors.fg, bg = colors.bg })
  hl('MsgSeparator', { fg = colors.bright_black, bg = colors.bg })
  hl('ErrorMsg', { fg = colors.error, bold = true })
  hl('WarningMsg', { fg = colors.warning, bold = true })
  hl('MoreMsg', { fg = colors.green })
  hl('Question', { fg = colors.cyan })
  hl('Title', { fg = colors.yellow, bold = true })
  
  -- Diff
  hl('DiffAdd', { fg = colors.diff_add, bg = colors.black })
  hl('DiffChange', { fg = colors.diff_change, bg = colors.black })
  hl('DiffDelete', { fg = colors.diff_delete, bg = colors.black })
  hl('DiffText', { fg = colors.diff_text, bg = colors.bright_black })
  
  -- Spelling
  hl('SpellBad', { sp = colors.error, undercurl = true })
  hl('SpellCap', { sp = colors.warning, undercurl = true })
  hl('SpellLocal', { sp = colors.info, undercurl = true })
  hl('SpellRare', { sp = colors.hint, undercurl = true })
  
  -- Syntax Highlighting
  hl('Comment', { fg = colors.comment, italic = true })
  hl('Constant', { fg = colors.magenta })
  hl('String', { fg = colors.string })
  hl('Character', { fg = colors.green })
  hl('Number', { fg = colors.number })
  hl('Boolean', { fg = colors.magenta })
  hl('Float', { fg = colors.number })
  
  hl('Identifier', { fg = colors.fg })
  hl('Function', { fg = colors.function_name })
  
  hl('Statement', { fg = colors.keyword })
  hl('Conditional', { fg = colors.keyword })
  hl('Repeat', { fg = colors.keyword })
  hl('Label', { fg = colors.keyword })
  hl('Operator', { fg = colors.operator })
  hl('Keyword', { fg = colors.keyword })
  hl('Exception', { fg = colors.keyword })
  
  hl('PreProc', { fg = colors.red })
  hl('Include', { fg = colors.red })
  hl('Define', { fg = colors.red })
  hl('Macro', { fg = colors.red })
  hl('PreCondit', { fg = colors.red })
  
  hl('Type', { fg = colors.type })
  hl('StorageClass', { fg = colors.keyword })
  hl('Structure', { fg = colors.type })
  hl('Typedef', { fg = colors.type })
  
  hl('Special', { fg = colors.cyan })
  hl('SpecialChar', { fg = colors.cyan })
  hl('Tag', { fg = colors.cyan })
  hl('Delimiter', { fg = colors.punctuation })
  hl('SpecialComment', { fg = colors.bright_black, italic = true })
  hl('Debug', { fg = colors.red })
  
  hl('Underlined', { fg = colors.blue, underline = true })
  hl('Ignore', { fg = colors.bright_black })
  hl('Error', { fg = colors.error, bold = true })
  hl('Todo', { fg = colors.yellow, bold = true })
  
  -- Treesitter Highlights
  hl('@variable', { fg = colors.fg })
  hl('@variable.builtin', { fg = colors.magenta })
  hl('@variable.parameter', { fg = colors.blue })
  hl('@variable.member', { fg = colors.fg })
  
  hl('@constant', { fg = colors.magenta })
  hl('@constant.builtin', { fg = colors.magenta })
  hl('@constant.macro', { fg = colors.red })
  
  hl('@string', { fg = colors.string })
  hl('@string.escape', { fg = colors.cyan })
  hl('@string.special', { fg = colors.cyan })
  hl('@string.documentation', { fg = colors.comment, italic = true })
  hl('@character', { fg = colors.green })
  hl('@number', { fg = colors.number })
  hl('@boolean', { fg = colors.magenta })
  hl('@float', { fg = colors.number })
  
  hl('@function', { fg = colors.function_name })
  hl('@function.builtin', { fg = colors.green })
  hl('@function.macro', { fg = colors.red })
  hl('@function.method', { fg = colors.function_name })
  
  hl('@constructor', { fg = colors.yellow })
  hl('@parameter', { fg = colors.blue })
  
  hl('@keyword', { fg = colors.keyword })
  hl('@keyword.function', { fg = colors.keyword })
  hl('@keyword.operator', { fg = colors.keyword })
  hl('@keyword.return', { fg = colors.keyword })
  
  hl('@conditional', { fg = colors.keyword })
  hl('@repeat', { fg = colors.keyword })
  hl('@label', { fg = colors.keyword })
  hl('@operator', { fg = colors.operator })
  hl('@exception', { fg = colors.keyword })
  
  hl('@type', { fg = colors.type })
  hl('@type.builtin', { fg = colors.type })
  hl('@type.definition', { fg = colors.type })
  hl('@type.qualifier', { fg = colors.keyword })
  
  hl('@property', { fg = colors.fg })
  hl('@attribute', { fg = colors.cyan })
  
  hl('@comment', { fg = colors.comment, italic = true })
  hl('@comment.documentation', { fg = colors.comment, italic = true })
  hl('@comment.error', { fg = colors.error })
  hl('@comment.warning', { fg = colors.warning })
  hl('@comment.todo', { fg = colors.yellow, bold = true })
  hl('@comment.note', { fg = colors.info })
  
  hl('@punctuation.delimiter', { fg = colors.punctuation })
  hl('@punctuation.bracket', { fg = colors.punctuation })
  hl('@punctuation.special', { fg = colors.cyan })
  
  -- Rainbow brackets for better nesting visibility
  hl('RainbowDelimiterRed', { fg = colors.red })
  hl('RainbowDelimiterYellow', { fg = colors.yellow })
  hl('RainbowDelimiterBlue', { fg = colors.blue })
  hl('RainbowDelimiterOrange', { fg = colors.bright_yellow })
  hl('RainbowDelimiterGreen', { fg = colors.green })
  hl('RainbowDelimiterViolet', { fg = colors.magenta })
  hl('RainbowDelimiterCyan', { fg = colors.cyan })
  
  hl('@tag', { fg = colors.red })
  hl('@tag.attribute', { fg = colors.yellow })
  hl('@tag.delimiter', { fg = colors.punctuation })
  
  -- LSP Semantic Tokens
  hl('@lsp.type.class', { fg = colors.type })
  hl('@lsp.type.decorator', { fg = colors.cyan })
  hl('@lsp.type.enum', { fg = colors.type })
  hl('@lsp.type.enumMember', { fg = colors.magenta })
  hl('@lsp.type.function', { fg = colors.function_name })
  hl('@lsp.type.interface', { fg = colors.type })
  hl('@lsp.type.macro', { fg = colors.red })
  hl('@lsp.type.method', { fg = colors.function_name })
  hl('@lsp.type.namespace', { fg = colors.yellow })
  hl('@lsp.type.parameter', { fg = colors.blue })
  hl('@lsp.type.property', { fg = colors.fg })
  hl('@lsp.type.struct', { fg = colors.type })
  hl('@lsp.type.type', { fg = colors.type })
  hl('@lsp.type.typeParameter', { fg = colors.type })
  hl('@lsp.type.variable', { fg = colors.fg })
  
  -- LSP Diagnostics
  hl('DiagnosticError', { fg = colors.error })
  hl('DiagnosticWarn', { fg = colors.warning })
  hl('DiagnosticInfo', { fg = colors.info })
  hl('DiagnosticHint', { fg = colors.hint })
  
  hl('DiagnosticUnderlineError', { sp = colors.error, undercurl = true })
  hl('DiagnosticUnderlineWarn', { sp = colors.warning, undercurl = true })
  hl('DiagnosticUnderlineInfo', { sp = colors.info, undercurl = true })
  hl('DiagnosticUnderlineHint', { sp = colors.hint, undercurl = true })
  
  hl('DiagnosticVirtualTextError', { fg = colors.error, italic = true })
  hl('DiagnosticVirtualTextWarn', { fg = colors.warning, italic = true })
  hl('DiagnosticVirtualTextInfo', { fg = colors.info, italic = true })
  hl('DiagnosticVirtualTextHint', { fg = colors.hint, italic = true })
  
  hl('DiagnosticSignError', { fg = colors.error })
  hl('DiagnosticSignWarn', { fg = colors.warning })
  hl('DiagnosticSignInfo', { fg = colors.info })
  hl('DiagnosticSignHint', { fg = colors.hint })
  
  -- LSP References
  hl('LspReferenceText', { bg = colors.dark_gray })
  hl('LspReferenceRead', { bg = colors.dark_gray })
  hl('LspReferenceWrite', { bg = colors.dark_gray, underline = true })
  
  -- Git Signs
  hl('GitSignsAdd', { fg = colors.git_add })
  hl('GitSignsChange', { fg = colors.git_change })
  hl('GitSignsDelete', { fg = colors.git_delete })
  hl('GitSignsAddInline', { bg = colors.black, fg = colors.git_add })
  hl('GitSignsChangeInline', { bg = colors.black, fg = colors.git_change })
  hl('GitSignsDeleteInline', { bg = colors.black, fg = colors.git_delete })
  
  -- Telescope
  hl('TelescopeBorder', { fg = colors.bright_black, bg = colors.panel_bg })
  hl('TelescopeNormal', { fg = colors.fg, bg = colors.panel_bg })
  hl('TelescopePromptNormal', { fg = colors.fg, bg = colors.panel_bg })
  hl('TelescopePromptBorder', { fg = colors.cyan, bg = colors.panel_bg })
  hl('TelescopePromptTitle', { fg = colors.bg, bg = colors.cyan })
  hl('TelescopePromptPrefix', { fg = colors.cyan })
  hl('TelescopeSelection', { fg = colors.fg, bg = colors.dark_gray, bold = true })
  hl('TelescopeSelectionCaret', { fg = colors.cyan, bg = colors.dark_gray })
  hl('TelescopeMatching', { fg = colors.yellow, bold = true })
  hl('TelescopePreviewTitle', { fg = colors.bg, bg = colors.green })
  hl('TelescopeResultsTitle', { fg = colors.bg, bg = colors.blue })
  
  -- Neo-tree
  hl('NeoTreeNormal', { fg = colors.fg, bg = colors.panel_bg })
  hl('NeoTreeNormalNC', { fg = colors.fg, bg = colors.panel_bg })
  hl('NeoTreeDirectoryIcon', { fg = colors.blue })
  hl('NeoTreeDirectoryName', { fg = colors.blue })
  hl('NeoTreeFileName', { fg = colors.fg })
  hl('NeoTreeFileIcon', { fg = colors.fg })
  hl('NeoTreeGitAdded', { fg = colors.git_add })
  hl('NeoTreeGitModified', { fg = colors.git_change })
  hl('NeoTreeGitDeleted', { fg = colors.git_delete })
  hl('NeoTreeRootName', { fg = colors.cyan, bold = true })
  hl('NeoTreeIndentMarker', { fg = colors.bright_black })
  
  -- Indent Blankline
  hl('IblIndent', { fg = colors.bright_black })
  hl('IblScope', { fg = colors.cyan })
  
  -- Which-key
  hl('WhichKey', { fg = colors.cyan })
  hl('WhichKeyGroup', { fg = colors.yellow })
  hl('WhichKeyDesc', { fg = colors.fg })
  hl('WhichKeySeparator', { fg = colors.bright_black })
  hl('WhichKeyFloat', { bg = colors.panel_bg })
  
  -- Nvim-cmp
  hl('CmpItemAbbrMatch', { fg = colors.yellow, bold = true })
  hl('CmpItemAbbrMatchFuzzy', { fg = colors.yellow })
  hl('CmpItemKindVariable', { fg = colors.fg })
  hl('CmpItemKindFunction', { fg = colors.function_name })
  hl('CmpItemKindMethod', { fg = colors.function_name })
  hl('CmpItemKindClass', { fg = colors.type })
  hl('CmpItemKindInterface', { fg = colors.type })
  hl('CmpItemKindStruct', { fg = colors.type })
  hl('CmpItemKindKeyword', { fg = colors.keyword })
  hl('CmpItemKindText', { fg = colors.fg })
  hl('CmpItemKindSnippet', { fg = colors.cyan })
  
  -- DAP (Debug Adapter Protocol)
  hl('DapBreakpoint', { fg = colors.error })
  hl('DapStopped', { fg = colors.warning })
  hl('DapBreakpointLine', { bg = colors.black })
  
  -- Flash.nvim
  hl('FlashBackdrop', { fg = colors.bright_black })
  hl('FlashLabel', { fg = colors.bg, bg = colors.yellow, bold = true })
  hl('FlashMatch', { fg = colors.cyan, bold = true })
  
  -- Markdown
  hl('@markup.heading', { fg = colors.red, bold = true })
  hl('@markup.heading.1', { fg = colors.red, bold = true })
  hl('@markup.heading.2', { fg = colors.magenta, bold = true })
  hl('@markup.heading.3', { fg = colors.blue, bold = true })
  hl('@markup.heading.4', { fg = colors.cyan, bold = true })
  hl('@markup.heading.5', { fg = colors.bright_yellow, bold = true })
  hl('@markup.heading.6', { fg = colors.bright_magenta, bold = true })
  hl('@markup.link', { fg = colors.blue, underline = true })
  hl('@markup.link.label', { fg = colors.cyan })
  hl('@markup.link.url', { fg = colors.blue, italic = true })
  hl('@markup.raw', { fg = colors.green })
  hl('@markup.list', { fg = colors.cyan })
  hl('@markup.emphasis', { fg = colors.magenta, italic = true })
  hl('@markup.strong', { fg = colors.yellow, bold = true })
  hl('@markup.quote', { fg = colors.white, italic = true })
end

return M
