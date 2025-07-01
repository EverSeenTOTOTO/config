require('noice').setup({
  views = {
    cmdline_popup = {
      position = { row = '50%', col = '50%' },
    },
  },
  lsp = {
    override = {
      ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
      ['vim.lsp.util.stylize_markdown'] = true,
      ['cmp.entry.get_documentation'] = true, -- requires hrsh7th/nvim-cmp
    },
    hover = {
      enabled = false,
    },
  },
  routes = {
    {
      filter = {
        kind = 'spinner',
      },
      view = 'mini',
      opts = {
        replace = true,
        stop = true, -- stop filter chain
      },
    },
  },
  presets = {
    bottom_search = false,
    command_palette = true,
    long_message_to_split = true,
    inc_rename = false,
    lsp_doc_border = true,
  },
})

require('telescope').load_extension('noice')
