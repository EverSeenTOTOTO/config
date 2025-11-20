require('tokyonight').setup({
  on_colors = function(colors) colors.comment = '#a09a91' end,
  on_highlights = function(highlights)
    highlights.DiagnosticUnnecessary = {
      fg = '#a09a91',
    }
  end,
})

vim.cmd('highlight clear')
if vim.fn.exists('syntax_on') then vim.cmd('syntax reset') end
vim.cmd([[colorscheme iceberg]])

local hl = vim.api.nvim_set_hl

-- only for iceberg
local colors = require('core.colors')

hl(0, 'CursorLine', { bg = colors.grey_4 })
hl(0, 'Visual', { bg = colors.grey_1 })
