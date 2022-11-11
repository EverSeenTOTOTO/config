local status_ok, indent_blankline = pcall(require, "indent_blankline")

if status_ok then
	indent_blankline.setup({
		use_treesitter = false,
		show_end_of_line = false,
	})
end
