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
