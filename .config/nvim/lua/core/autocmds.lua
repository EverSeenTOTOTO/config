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
autocmd('Filetype', {
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

local has_mac = vim.fn.has('mac') == 1
local xdg_session_type = vim.env.XDG_SESSION_TYPE
local is_x11 = xdg_session_type == 'x11' and vim.fn.executable('xclip') == 1
local is_wayland = xdg_session_type == 'wayland' and vim.fn.executable('wl-copy') == 1

autocmd('TextYankPost', {
  pattern = '*',
  callback = function()
    -- Handle system clipboard integration
    if has_mac then
      vim.fn.system('pbcopy && tmux set-buffer "$(reattach-to-user-namespace pbpaste)"', vim.fn.getreg('"'))
    elseif is_x11 then
      -- xclip
      vim.fn.system('xclip -i -sel c && tmux set-buffer $(xclip -o -sel c)', vim.fn.getreg('"'))
    elseif is_wayland then
      -- wl-clipboard
      vim.fn.system('wl-copy && tmux set-buffer $(wl-paste)', vim.fn.getreg('"'))
    end

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

-- Automatically track files in nvim-tree
autocmd('BufEnter', {
  callback = function()
    local path = vim.fn.expand('%:p')
    if vim.o.buftype == '' and path ~= '' then
      local api = require('nvim-tree.api')

      api.tree.find_file({ open = false, focus = false })
    end
  end,
})

-- make it easier to close man-files when opened inline
autocmd('FileType', {
  pattern = { 'man' },
  callback = function(event) vim.bo[event.buf].buflisted = false end,
})

-- fold
autocmd({ 'FileType' }, {
  callback = function()
    if require('nvim-treesitter.parsers').has_parser() then
      vim.opt.foldmethod = 'expr'
      vim.opt.foldexpr = 'nvim_treesitter#foldexpr()'
    else
      -- use alternative foldmethod
      vim.opt.foldmethod = 'syntax'
    end
  end,
})

-- resize splits if window got resized
vim.api.nvim_create_autocmd({ 'VimResized' }, {
  callback = function()
    local current_tab = vim.fn.tabpagenr()
    vim.cmd('tabdo wincmd =')
    vim.cmd('tabnext ' .. current_tab)
  end,
})

vim.api.nvim_create_autocmd({ 'FileType' }, {
  pattern = { 'json', 'jsonc', 'json5' },
  callback = function() vim.opt_local.conceallevel = 0 end,
})

-- go to last loc when opening a buffer
vim.api.nvim_create_autocmd('BufReadPost', {
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
