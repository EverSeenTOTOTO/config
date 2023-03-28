local create_user_command = vim.api.nvim_create_user_command;

create_user_command("RenameCurrentFile", function()
  local old_name = vim.api.nvim_command_output("echo expand('%')")
  local new_name = vim.fn.input("New file name: ", old_name, "file")

  if new_name ~= '' and new_name ~= old_name then
    vim.cmd("sav  " .. new_name .. "")
    vim.cmd("silent !rm " .. old_name .. "")
    vim.cmd([[ redraw! ]])
  end
end, {})

create_user_command("SplitCurrentLine", function()
  local sep = vim.fn.input("Seperator: ")
  local buf = vim.api.nvim_get_current_buf()
  local row = vim.api.nvim_win_get_cursor(vim.api.nvim_get_current_win())[1]

  local lines = vim.split(vim.api.nvim_get_current_line(), sep)

  for i = 1, #lines - 1 do
    lines[i] = lines[i] .. sep
  end

  vim.api.nvim_buf_set_lines(buf, row - 1, row, false, lines)
end, {})
