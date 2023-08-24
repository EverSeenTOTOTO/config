local tabnine = require("cmp_tabnine.config")

tabnine:setup({
	ignored_file_types = {
		html = true,
		markdown = true,
	},
})
