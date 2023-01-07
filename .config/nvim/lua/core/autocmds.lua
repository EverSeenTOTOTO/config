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

-- automatically create directories
autocmd("BufWritePre", {
  pattern = "*",
  callback = function(ctx)
    local dir = vim.fn.fnamemodify(ctx.file, ":p:h")
    vim.fn.mkdir(dir, "p")
  end
})

-- highlight yanked text for 700ms
autocmd("TextYankPost", {
  pattern = "*",
  callback = function()
    vim.highlight.on_yank { higroup = "IncSearch", timeout = 700 }
  end
})
