local ok, chatgpt = pcall(require, "chatgpt")

if not ok then
	return
end

chatgpt.setup({
	edit_with_instructions = {
		diff = false,
		keymaps = {
			close = "vv",
			use_output_as_input = "<Enter>",
		},
	},
	chat = {
		keymaps = {
			close = { "vv" },
		},
	},
})
