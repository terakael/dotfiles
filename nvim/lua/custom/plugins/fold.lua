return {
  'kevinhwang91/nvim-ufo',
  dependencies = 'kevinhwang91/promise-async',
  config = function()
    local ufo = require 'ufo'

    ufo.setup {
      -- Prefer treesitter folds, fall back to indent for languages
      -- without a folds.scm query. This avoids the default LSP provider,
      -- which only fires if a server advertises foldingRangeProvider.
      provider_selector = function(bufnr, filetype, buftype)
        return { 'treesitter', 'indent' }
      end,
      -- Close specific fold kinds when a buffer first opens. Treesitter
      -- exposes parser node types as kinds - run `UfoInspect` on a buffer
      -- to see the exact names for a language.
      close_fold_kinds_for_ft = {
        java = { 'import_declaration' },
        python = { 'import_statement' },
        rust = { 'use_declaration' },
      },
      fold_virt_text_handler = function(virtText, lnum, endLnum, width, truncate)
        -- Show a "  N " count on folded lines, truncated to fit the window
        local newVirtText = {}
        local suffix = ('  %d '):format(endLnum - lnum)
        local sufWidth = vim.fn.strdisplaywidth(suffix)
        local targetWidth = width - sufWidth
        local curWidth = 0
        for _, chunk in ipairs(virtText) do
          local chunkText = chunk[1]
          local chunkWidth = vim.fn.strdisplaywidth(chunkText)
          if targetWidth > curWidth + chunkWidth then
            table.insert(newVirtText, chunk)
          else
            chunkText = truncate(chunkText, targetWidth - curWidth)
            local hlGroup = chunk[2]
            table.insert(newVirtText, { chunkText, hlGroup })
            chunkWidth = vim.fn.strdisplaywidth(chunkText)
            if curWidth + chunkWidth < targetWidth then
              suffix = suffix .. (' '):rep(targetWidth - curWidth - chunkWidth)
            end
            break
          end
          curWidth = curWidth + chunkWidth
        end
        table.insert(newVirtText, { suffix, 'MoreMsg' })
        return newVirtText
      end,
    }

    -- ufo needs a high foldlevel; it sets foldmethod=manual itself
    vim.o.foldcolumn = '0'
    vim.o.foldlevel = 99
    vim.o.foldlevelstart = 99
    vim.o.foldenable = true

    vim.keymap.set('n', 'zR', ufo.openAllFolds, { desc = 'Open all folds' })
    vim.keymap.set('n', 'zM', ufo.closeAllFolds, { desc = 'Close all folds' })
    vim.keymap.set('n', 'zr', ufo.openFoldsExceptKinds, { desc = 'Open folds by kind' })
    vim.keymap.set('n', 'zm', ufo.closeFoldsWith, { desc = 'Close folds by kind' })

    -- Harpoon (and other tools) pre-load a buffer with bufload() before
    -- showing it via nvim_set_current_buf. ufo attaches the buffer during
    -- bufload() when it has no window yet, so it skips the fold update, and
    -- skips the first-apply that auto-closes imports. Re-trigger the fold
    -- update on BufWinEnter so folds and import auto-closing still apply.
    -- enableFold() is idempotent and cheap for unchanged buffers.
    vim.api.nvim_create_autocmd('BufWinEnter', {
      group = vim.api.nvim_create_augroup('ufo-refresh', { clear = true }),
      callback = function()
        vim.schedule(function()
          ufo.enableFold()
        end)
      end,
    })
  end,
}
