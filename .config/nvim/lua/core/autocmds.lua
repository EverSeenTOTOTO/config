local autocmd = vim.api.nvim_create_autocmd

vim.api.nvim_create_augroup("setfiletype", { clear = true })

autocmd("BufRead,BufNewFile", {
	pattern = "*.env.*",
	group = "setfiletype",
	callback = function()
		vim.cmd("setfiletype sh")
	end,
})

autocmd("BufRead,BufNewFile", {
	pattern = "*.s",
	group = "setfiletype",
	callback = function()
		vim.cmd("setfiletype asm")
	end,
})

autocmd("BufRead,BufNewFile", {
	pattern = "*.svelte",
	group = "setfiletype",
	callback = function()
		vim.cmd("setfiletype html")
	end,
})

autocmd("BufRead,BufNewFile", {
	pattern = "*.wiki",
	group = "setfiletype",
	callback = function()
		vim.cmd("setfiletype markdown")
	end,
})

-- File extension specific tabbing
autocmd("Filetype", {
	pattern = "python",
	callback = function()
		vim.opt_local.expandtab = true
		vim.opt_local.tabstop = 4
		vim.opt_local.shiftwidth = 4
		vim.opt_local.softtabstop = 4
	end,
})

-- automatically create directories
autocmd("BufWritePre", {
	pattern = "*",
	callback = function(ctx)
		local dir = vim.fn.fnamemodify(ctx.file, ":p:h")
		vim.fn.mkdir(dir, "p")
	end,
})

-- highlight yanked text for 700ms
autocmd("TextYankPost", {
	pattern = "*",
	callback = function()
		if vim.fn.has("mac") then
			vim.cmd([[call system('pbcopy && tmux set-buffer "$(reattach-to-user-namespace pbpaste)"', @")]])
		else
			local type = vim.fn.nvim_command("echo $XDG_SESSION_TYPE")

			if type == "x11" and vim.fn.nvim_command("command -v xclip") ~= "" then
				-- xclip
				vim.cmd([[call system('xclip -i -sel c && tmux set-buffer $(xclip -o -sel c)', @")]])
			elseif type == "wayland" and vim.fn.nvim_command("command -v wayland") ~= "" then
				-- wl-clipboard
				vim.cmd([[call system('wl-copy && tmux set-buffer $(wl-paste)', @")]])
			end
		end

		vim.highlight.on_yank({ higroup = "IncSearch", timeout = 700 })
	end,
})
