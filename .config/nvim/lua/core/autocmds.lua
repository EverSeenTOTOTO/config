local autocmd = vim.api.nvim_create_autocmd

autocmd("BufRead,BufNewFile", {
	pattern = "*.env.*",
	callback = function()
		vim.cmd("setfiletype sh")
	end,
})

autocmd("BufRead,BufNewFile", {
	pattern = "*.s",
	callback = function()
		vim.cmd("setfiletype asm")
	end,
})

autocmd("BufRead,BufNewFile", {
	pattern = "*.svelte",
	callback = function()
		vim.cmd("setfiletype html")
	end,
})

autocmd("BufRead,BufNewFile", {
	pattern = "*.wiki",
	callback = function()
		vim.cmd("setfiletype markdown")
	end,
})

-- Open a file from its last left off position
autocmd("BufReadPost", {
	pattern = "*.*",
	callback = function()
		if
			not vim.fn.expand("%:p"):match(".git")
			and vim.fn.line("'\"") > 1
			and vim.fn.line("'\"") <= vim.fn.line("$")
		then
			vim.cmd("normal! g'\"")
			vim.cmd("normal zz")
		end
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

autocmd("BufWritePre", {
	pattern = "*.tsx,*.ts,*.jsx,*.js,*.vue",
	callback = function()
		for _, client in pairs(vim.lsp.buf_get_clients(0)) do
			if client.name == "eslint" then
				vim.cmd(":EslintFixAll")
			end
		end
	end,
})
