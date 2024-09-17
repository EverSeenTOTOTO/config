local create_usercmd = vim.api.nvim_create_user_command

create_usercmd("SplitCurrentLine", function()
  vim.ui.input({
    prompt = "Seperator: ",
    default = " ",
  }, function(sep)
    local buf = vim.api.nvim_get_current_buf()
    local row, col = unpack(vim.api.nvim_win_get_cursor(0))
    local lines = vim.split(vim.api.nvim_buf_get_lines(buf, row - 1, row, false)[1], sep, {
      trimempty = true
    })

    vim.api.nvim_buf_set_lines(buf, row - 1, row, false, lines)
    vim.api.nvim_win_set_cursor(0, { row, col })
  end)
end, {})

create_usercmd("TsOrganizeImports", function()
  vim.lsp.buf.execute_command({
    command = "typescript.organizeImports",
    arguments = { vim.api.nvim_buf_get_name(0) },
    title = "",
  })
end, {})
