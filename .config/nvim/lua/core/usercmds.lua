local create_usercmd = vim.api.nvim_create_user_command

create_usercmd("SplitCurrentLine", function()
	vim.ui.input({
		prompt = "Seperator: ",
		default = " ",
	}, function(sep)
		local buf = vim.api.nvim_get_current_buf()
		local row, col = unpack(vim.api.nvim_win_get_cursor(0))
		local line = vim.api.nvim_buf_get_lines(buf, row - 1, row, false)[1]
		local lines = vim.split(line, sep:gsub("^%s*(.-)%s*$", "%1"):gsub("^$", " "), {
			plain = true,
			trimempty = true,
		})

		vim.api.nvim_buf_set_lines(buf, row - 1, row, false, lines)
		vim.api.nvim_win_set_cursor(0, { row, col })
	end)
end, {})
