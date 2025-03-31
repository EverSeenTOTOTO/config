require("tokyonight").setup({
	on_colors = function(colors)
		colors.comment = "#a09a91"
	end,
	on_highlights = function(highlights)
		highlights.DiagnosticUnnecessary = {
			fg = "#a09a91",
		}
	end,
})
vim.cmd([[colorscheme tokyonight-moon]])
