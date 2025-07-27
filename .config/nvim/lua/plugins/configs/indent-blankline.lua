local status_ok, ibl = pcall(require, 'ibl')

if not status_ok then return end

local utils = require('core.utils')

ibl.setup({
  exclude = {
    filetypes = utils.exclude_filetypes,
  },
})
