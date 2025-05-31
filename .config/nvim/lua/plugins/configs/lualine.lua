local status_ok, lualine = pcall(require, 'lualine')

if not status_ok then return end

lualine.setup({
  options = {
    component_separators = '',
    section_separators = '',
  },
  sections = {
    lualine_a = { 'mode' },
    lualine_b = { { 'branch', separator = { right = '' } } },
    lualine_c = {},
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
      function()
        local server = vim.lsp.status()[1]
        return server
            and string.format(
              ' %%<%s %s %s (%s%%%%) ',
              ((server.percentage or 0) >= 70 and { '', '', '' } or { '', '', '' })[math.floor(
                vim.uv.hrtime() / 12e7
              ) % 3 + 1],
              server.title or '',
              server.message or '',
              server.percentage or 0
            )
            or ''
      end,
    },
    lualine_y = {
      { 'encoding', separator = { left = '' } },
    },
    lualine_z = {
      'location',
    },
  },
  extensions = {
    'fzf',
    'lazy',
    'nvim-tree',
  },
})
