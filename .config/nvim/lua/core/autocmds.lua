local autocmd = vim.api.nvim_create_autocmd

vim.api.nvim_create_augroup('setfiletype', { clear = true })

autocmd({ 'BufRead', 'BufNewFile' }, {
  pattern = '*.env.*',
  group = 'setfiletype',
  callback = function() vim.cmd('setfiletype sh') end,
})

autocmd({ 'BufRead', 'BufNewFile' }, {
  pattern = '*.s',
  group = 'setfiletype',
  callback = function() vim.cmd('setfiletype asm') end,
})

autocmd({ 'BufRead', 'BufNewFile' }, {
  pattern = '*.svelte',
  group = 'setfiletype',
  callback = function() vim.cmd('setfiletype html') end,
})

autocmd({ 'BufRead', 'BufNewFile' }, {
  pattern = '*.wiki',
  group = 'setfiletype',
  callback = function() vim.cmd('setfiletype markdown') end,
})

-- File extension specific tabbing
autocmd('FileType', {
  pattern = 'python',
  callback = function()
    vim.opt_local.expandtab = true
    vim.opt_local.tabstop = 4
    vim.opt_local.shiftwidth = 4
    vim.opt_local.softtabstop = 4
  end,
})

-- automatically create directories
autocmd('BufWritePre', {
  pattern = '*',
  callback = function(ctx)
    local dir = vim.fn.fnamemodify(ctx.file, ':p:h')
    vim.fn.mkdir(dir, 'p')
  end,
})

autocmd('LspAttach', {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client:supports_method('textDocument/foldingRange') then
      local win = vim.api.nvim_get_current_win()
      vim.wo[win][0].foldexpr = 'v:lua.vim.lsp.foldexpr()'
    end
  end,
})

autocmd('TextYankPost', {
  pattern = '*',
  callback = function()
    -- highlight yanked text for 700ms
    vim.highlight.on_yank({ higroup = 'IncSearch', timeout = 700 })
  end,
})

-- Check if we need to reload the file when it changed
autocmd('FocusGained', {
  callback = function()
    if vim.o.buftype ~= 'nofile' then vim.cmd('checktime') end
  end,
})

-- make it easier to close man-files when opened inline
autocmd('FileType', {
  pattern = { 'man' },
  callback = function(event) vim.bo[event.buf].buflisted = false end,
})

-- resize splits if window got resized
autocmd({ 'VimResized' }, {
  callback = function()
    local current_tab = vim.fn.tabpagenr()
    vim.cmd('tabdo wincmd =')
    vim.cmd('tabnext ' .. current_tab)
  end,
})

autocmd({ 'FileType' }, {
  pattern = { 'json', 'jsonc', 'json5' },
  callback = function() vim.opt_local.conceallevel = 0 end,
})

-- go to last loc when opening a buffer
autocmd('BufReadPost', {
  callback = function(event)
    local exclude = { 'gitcommit' }
    local buf = event.buf
    if vim.tbl_contains(exclude, vim.bo[buf].filetype) or vim.b[buf].lazyvim_last_loc then return end
    vim.b[buf].lazyvim_last_loc = true
    local mark = vim.api.nvim_buf_get_mark(buf, '"')
    local lcount = vim.api.nvim_buf_line_count(buf)
    if mark[1] > 0 and mark[1] <= lcount then pcall(vim.api.nvim_win_set_cursor, 0, mark) end
  end,
})

autocmd({ 'BufRead', 'BufNewFile' }, {
  callback = function()
    local path = vim.fn.expand('%:p')
    if vim.o.buftype == '' and path ~= '' then
      local api = require('nvim-tree.api')

      api.tree.find_file({ open = false, focus = false })
    end
  end,
})

autocmd('BufEnter', {
  callback = function()
    local path = vim.fn.expand('%:p')
    if vim.o.buftype == '' and path ~= '' then
      local api = require('nvim-tree.api')

      api.tree.find_file({ open = false, focus = false })
    end
  end,
})

autocmd('FileType', {
  pattern = 'grug-far',
  callback = function() vim.g.maplocalleader = ';' end,
})
