return { -- Autocompletion with blink.cmp
  'saghen/blink.cmp',
  version = '0.*',
  dependencies = {
    'rafamadriz/friendly-snippets',
    'folke/lazydev.nvim',
  },
  opts = {
    keymap = {
      preset = 'default',
      ['<C-k>'] = { 'show', 'show_documentation', 'hide_documentation' },
      ['<C-e>'] = { 'hide' },
      ['<C-y>'] = { 'select_and_accept' },
      ['<C-p>'] = { 'select_prev', 'fallback' },
      ['<C-n>'] = { 'select_next', 'fallback' },
      ['<C-u>'] = { 'scroll_documentation_up', 'fallback' },
      ['<C-d>'] = { 'scroll_documentation_down', 'fallback' },
      ['<C-l>'] = { 'snippet_forward', 'fallback' },
      ['<C-h>'] = { 'snippet_backward', 'fallback' },
    },
    appearance = {
      use_nvim_cmp_as_default = true,
      nerd_font_variant = 'mono',
    },
    sources = {
      default = { 'lsp', 'path', 'snippets', 'buffer', 'lazydev' },
      per_filetype = {
        sql = { 'snippets', 'dadbod', 'buffer' },
      },
      providers = {
        lazydev = {
          name = 'LazyDev',
          module = 'lazydev.integrations.blink',
          score_offset = 100, -- show at a higher priority than lsp
        },
        dadbod = {
          name = 'Dadbod',
          module = 'vim_dadbod_completion.blink',
          score_offset = 90,
        },
      },
    },
    completion = {
      menu = {
        border = 'rounded',
        draw = {
          columns = { { 'label', 'label_description', gap = 1 }, { 'kind_icon', 'kind' } },
        },
      },
      documentation = {
        auto_show = true,
        auto_show_delay_ms = 500,
        window = { border = 'rounded' },
      },
    },
    signature = {
      enabled = true,
      window = { border = 'rounded' },
    },
  },
}
