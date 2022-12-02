local present, bufferline = pcall(require, "bufferline")
if not present then
	return
end

local options = {
	options = {
		always_show_bufferline = true,
		buffer_close_icon = "",
		diagnostics = "nvim_lsp",
		diagnostics_update_in_insert = false,
		enforce_regular_tabs = false,
		hover = { enabled = true, reveal = { "close" } },
		left_trunc_marker = "",
		max_name_length = 18,
		max_prefix_length = 15,
		modified_icon = "",
		offsets = { { filetype = "NvimTree", text = "", padding = 1 } },
		right_trunc_marker = "",
		separator_style = "thin",
		show_buffer_close_icons = true,
		show_close_icon = false,
		show_tab_indicators = true,
		tab_size = 18,
		view = "multiwindow",
	},
}

bufferline.setup(options)
