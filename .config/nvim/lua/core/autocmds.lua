local autocmd = vim.api.nvim_create_autocmd

vim.api.nvim_create_augroup("setfiletype", { clear = true })

autocmd({ "BufRead", "BufNewFile" }, {
	pattern = "*.env.*",
	group = "setfiletype",
	callback = function()
		vim.cmd("setfiletype sh")
	end,
})

autocmd({ "BufRead", "BufNewFile" }, {
	pattern = "*.s",
	group = "setfiletype",
	callback = function()
		vim.cmd("setfiletype asm")
	end,
})

autocmd({ "BufRead", "BufNewFile" }, {
	pattern = "*.svelte",
	group = "setfiletype",
	callback = function()
		vim.cmd("setfiletype html")
	end,
})

autocmd({ "BufRead", "BufNewFile" }, {
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
local has_mac = vim.fn.has("mac")
local xdg_session_type = vim.api.nvim_command("echo $XDG_SESSION_TYPE")
local is_x11 = xdg_session_type == "x11" and vim.api.nvim_command("command -v xclip") ~= ""
local is_wayland = xdg_session_type == "wayland" and vim.api.nvim_command("command -v wayland") ~= ""

autocmd("TextYankPost", {
	pattern = "*",
	callback = function()
		if has_mac then
			vim.cmd([[call system('pbcopy && tmux set-buffer "$(reattach-to-user-namespace pbpaste)"', @")]])
		else
			if is_x11 then
				-- xclip
				vim.cmd([[call system('xclip -i -sel c && tmux set-buffer $(xclip -o -sel c)', @")]])
			elseif is_wayland then
				-- wl-clipboard
				vim.cmd([[call system('wl-copy && tmux set-buffer $(wl-paste)', @")]])
			end
		end

		vim.highlight.on_yank({ higroup = "IncSearch", timeout = 700 })
	end,
})

-- Check if we need to reload the file when it changed
autocmd("FocusGained", {
	callback = function()
		if vim.o.buftype ~= "nofile" then
			vim.cmd("checktime")
		end
	end,
})

autocmd("BufEnter", {
	callback = function()
		local path = vim.fn.expand("%:p")
		if vim.o.buftype == "" and path ~= "" then
			local api = require("nvim-tree.api")

			api.tree.find_file({ open = false, focus = false })
		end
	end,
})

-- make it easier to close man-files when opened inline
autocmd("FileType", {
	pattern = { "man" },
	callback = function(event)
		vim.bo[event.buf].buflisted = false
	end,
})
