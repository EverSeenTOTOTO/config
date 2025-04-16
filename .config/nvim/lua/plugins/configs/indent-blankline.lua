local status_ok, ibl = pcall(require, 'ibl')

if status_ok then
  ibl.setup({
    indent = {
      char = '▏',
    },
    exclude = {
      buftypes = {
        'terminal',
        'nofile',
      },
      filetypes = {
        'help',
        'startify',
        'dashboard',
        'packer',
        'neogitstatus',
        'NvimTree',
      },
    },
  })
end
