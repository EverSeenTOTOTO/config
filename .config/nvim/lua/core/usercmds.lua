local create_usercmd = vim.api.nvim_create_user_command

create_usercmd('TsOrganizeImports', function()
  for _, client in ipairs(vim.lsp.get_clients({ bufnr = 0 })) do
    if client.name == 'vtsls' then
      client:request('workspace/executeCommand', {
        command = 'typescript.organizeImports',
        arguments = { vim.api.nvim_buf_get_name(0) },
        title = '',
      })
    end
  end
end, {})

create_usercmd('SplitCurrentLine', function()
  vim.ui.input({
    prompt = 'Separator: ',
    default = ' ',
  }, function(sep)
    local cursor = vim.api.nvim_win_get_cursor(0)

    if not cursor or not sep then return end

    local buf = vim.api.nvim_get_current_buf()
    local row, col = unpack(cursor)
    local line = vim.api.nvim_buf_get_lines(buf, row - 1, row, false)[1]
    local lines = vim.split(line, sep:gsub('^%s*(.-)%s*$', '%1'):gsub('^$', ' '), {
      plain = true,
      trimempty = true,
    })

    vim.api.nvim_buf_set_lines(buf, row - 1, row, false, lines)
    vim.api.nvim_win_set_cursor(0, { row, col })
  end)
end, {})
