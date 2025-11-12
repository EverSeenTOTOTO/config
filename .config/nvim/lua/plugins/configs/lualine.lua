local status_ok, lualine = pcall(require, 'lualine')

if not status_ok then return end

lualine.setup({
  options = {
    component_separators = '',
    section_separators = '',
  },
  sections = {
    lualine_a = { 'mode' },
    lualine_b = {
      {
        'branch',
        separator = { right = '' },
      },
    },
    lualine_c = {
      {
        -- recording @x
        require('noice').api.statusline.mode.get,
        cond = require('noice').api.statusline.mode.has,
        color = {
          fg = '#FF6B6B',
          gui = 'bold',
        },
      },
    },
    lualine_x = {
      {
        'diagnostics',
      },
      function()
        local buf_client_names = {}
        local clients = vim.lsp.get_clients({
          bufnr = vim.api.nvim_get_current_buf(),
        })
        for _, client in pairs(clients) do
          table.insert(buf_client_names, client.name)
        end
        return table.concat(buf_client_names, ', ')
      end,
    },
    lualine_y = {
      { 'encoding', separator = { left = '' } },
    },
    lualine_z = {
      'location',
    },
  },
  tabline = {
    lualine_a = { 'buffers' },
    lualine_z = { 'tabs' }
  },
  extensions = {
    'fzf',
    'lazy',
    'nvim-tree',
  },
})
