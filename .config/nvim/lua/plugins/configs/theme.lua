vim.cmd('highlight clear')

if vim.fn.exists('syntax_on') then vim.cmd('syntax reset') end

local hl = vim.api.nvim_set_hl

vim.api.nvim_create_autocmd('ColorScheme', {
  pattern = '*',
  callback = function()
    if vim.g.colors_name == 'iceberg' then
      hl(0, 'CursorLine', { bg = '#2a3158' })
      hl(0, 'Visual', { bg = '#3e445e' })
      hl(0, 'TabLineFill', {
        cterm = nil,
        ctermbg = 238,
        ctermfg = 233,
        bg = '#3e445e',
        fg = '#0f1117',
      })
    end

    if vim.g.colors_name == 'tokyonight' then
      hl(0, 'DiagnosticUnnecessary', { fg = '#a09a91' })
      hl(0, 'Comment', { fg = '#a09a91' })
    end
  end,
})

vim.cmd([[colorscheme iceberg]])
