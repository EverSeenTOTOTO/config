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
        color = { fg = '#bf764a' },
        -- show current treesitter node type
        function()
          local row, col = unpack(vim.api.nvim_win_get_cursor(0))
          row = row - 1 -- treesitter uses 0-based indexing

          local parser = vim.treesitter.get_parser()

          local tree = parser:parse()[1]
          local node = tree:root():named_descendant_for_range(row, col, row, col)

          if node then return string.format('󰉿 %s', node:type()) end
          return ''
        end,
        cond = function()
          local buf = vim.api.nvim_get_current_buf()
          local ft = vim.bo[buf].filetype

          local lang = vim.treesitter.language.get_lang(ft)
          if not lang then return false end
          local ok, parser = pcall(vim.treesitter.get_parser, buf, lang)
          return ok and parser ~= nil
        end,
      },
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
  extensions = {
    'fzf',
    'lazy',
    'nvim-tree',
  },
})
