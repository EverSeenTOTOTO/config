local autocmd = vim.api.nvim_create_autocmd

-- regard svelte file as html
autocmd("BufEnter", {
  pattern = "*.svelte",
  callback = function()
    vim.cmd "setl filetype=html"
  end,
})

-- Open a file from its last left off position
autocmd("BufReadPost", {
  pattern = "*.*",
  callback = function()
    if not vim.fn.expand("%:p"):match ".git" and vim.fn.line "'\"" > 1 and vim.fn.line "'\"" <= vim.fn.line "$" then
      vim.cmd "normal! g'\""
      vim.cmd "normal zz"
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

-- Auto format on write
autocmd("BufWritePre", {
  pattern = "*.*",
  callback = function()
    vim.lsp.buf.format()
  end,
})

autocmd("BufWritePre", {
  pattern = "*.tsx,*.ts,*.jsx,*.js,*.vue",
  callback = function()
    for _, client in pairs(vim.lsp.buf_get_clients(0)) do
      if client.name == 'eslint' then
        vim.cmd ":EslintFixAll"
      end
    end
  end
})

-- auto save and load fold
autocmd("BufWinLeave", {
  pattern = "*.*",
  callback = function()
    vim.cmd ":mkview!"
  end
})
autocmd("BufWinEnter", {
  pattern = "*.*",
  callback = function()
    vim.cmd ":silent loadview"
  end
})
