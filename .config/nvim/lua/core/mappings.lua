local map = function(mode, keys, command, opt)
  local options = { silent = true }

  if opt then
    options = vim.tbl_extend("force", options, opt)
  end

  if type(keys) == "table" then
    for _, keymap in ipairs(keys) do
      vim.keymap.set(mode, keymap, command, options)
    end
    return
  end

  vim.keymap.set(mode, keys, command, options)
end

-- MAPPINGS

-- Leader
vim.g.mapleader = ","

map("", "<leader><leader>", "%")
map("", "<space>", ":", { silent = false })
map({ "n", "i" }, "vv", "<esc>")

-- 行号
map("n", "<F2>", ":se nu! nu?<CR>")

-- 防止缩进取消选择
map("v", "<", "<gv")
map("v", ">", ">gv")

-- 窗口
map("", "<up>", ":res +5<CR>")
map("", "<down>", ":res -5<CR>")
map("", "<left>", ":vertical resize-5<CR>")
map("", "<right>", ":vertical resize+5<CR>")
map("", "d<up>", ":wincmd k<cr>:wincmd c<cr>:wincmd p<cr>")
map("", "d<down>", ":wincmd j<cr>:wincmd c<cr>:wincmd p<cr>")
map("", "d<left>", ":wincmd h<cr>:wincmd c<cr>:wincmd p<cr>")
map("", "d<right>", ":wincmd l<cr>:wincmd c<cr>:wincmd p<cr>")

-- 折行
map("n", "k", "gk")
map("n", "gk", "k")
map("n", "j", "gj")
map("n", "gj", "j")

-- search
map("n", "n", "nzz")
map("n", "N", "Nzz")
map("n", "*", "*zz")
map("n", "#", "#zz")
map("n", "g*", "g*zz")

-- HL
map({ "v", "n" }, "H", "g^")
map({ "v", "n" }, "L", "g$")

-- redo
map("n", "U", "<C-r>")

-- Alt + jk move lines
if vim.fn.has('mac') ~= 0 then
  map("n", "∆", "mz:m+<cr>`z")
  map("i", "∆", "<esc>mz:m+<cr>`zi")
  map("v", "∆", ":m'>+<cr>`<my`>mzgv`yo`z")
  map("i", "˚", "<esc>mz:m-2<cr>`zi")
  map("n", "˚", "mz:m-2<cr>`z")
  map("v", "˚", ":m'<-2<cr>`>my`<mzgv`yo`z")
else
  map("n", "<M-j>", "mz:m+<cr>`z")
  map("i", "<M-j>", "<esc>mz:m+<cr>`zi")
  map("v", "<M-j>", ":m'>+<cr>`<my`>mzgv`yo`z")
  map("i", "<M-k>", "<esc>mz:m-2<cr>`zi")
  map("n", "<M-k>", "mz:m-2<cr>`z")
  map("v", "<M-k>", ":m'<-2<cr>`>my`<mzgv`yo`z")
end

-- copy
if vim.fn.has('mac') ~= 0 then
  map("v", "y",
    "mvy:call system('pbcopy && tmux set-buffer \"$(reattach-to-user-namespace pbpaste)\"', @\")<CR>`v")
else
  map("v", "y", "mvy:call system('xclip -i -sel c && tmux set-buffer \"$(xclip -o -sel c)\"', @\")<CR>`v")
end

-- Don't copy the replaced text after pasting in visual mode
map("v", "p", "p:let @+=@0<CR>")

-- use ESC to turn off search highlighting
map("n", "<Esc>", "<cmd>:noh<CR>")

-- move cursor within insert mode
map("i", "<C-a>", "<Home>")
map("i", "<C-b>", "<esc>bi")
map("i", "<C-e>", "<End>")
map("i", "<C-f>", "<esc>ea")
map("i", "<C-h>", "<Left>")
map("i", "<C-j>", "<Down>")
map("i", "<C-k>", "<Up>")
map("i", "<C-l>", "<Right>")
map("i", "<C-o>", "<esc>O")

map({ "i", "s" }, "<C-n>", function()
  require('luasnip').jump(1)
end)
map({ "i", "s" }, "<C-p>", function()
  require('luasnip').jump(-1)
end)

-- navigation between windows
vim.g.tmux_navigator_no_mappings = 1

map("n", "<C-h>", ":TmuxNavigateLeft<cr>")
map("n", "<C-j>", ":TmuxNavigateDown<cr>")
map("n", "<C-k>", ":TmuxNavigateUp<cr>")
map("n", "<C-l>", ":TmuxNavigateRight<cr>")

-- terminal
map("n", "<C-t>", ":term<cr>")
map("t", "vv", "<C-\\><C-n>")

if vim.api.nvim_command_output("echo has('unix')") == 1 then
  map("n", "gx", ':execute "!xdg-open" expand(\'%:p:h\') . "/" . expand("<cfile>") " &"<cr>end')
end

local M = {}

-- below are all plugin related mappings

-- lsp

map("n", "<leader>f", function()
  vim.lsp.buf.format()
end)

map("n", "<leader>h", function()
  vim.lsp.buf.hover()
  vim.lsp.buf.hover() -- call twice to jump to float window
end)

map("n", "<leader>n", function()
  vim.lsp.buf.rename()
end)

map("n", "<leader>a", function()
  vim.lsp.buf.code_action()
end)

map("n", "<leader>[", function()
  vim.diagnostic.goto_prev()
end)

map("n", "<leader>]", function()
  vim.diagnostic.goto_next()
end)

M.bufferline = function()
  map("n", "<TAB>", "<cmd> :BufferLineCycleNext <CR>")
  map("n", "<S-Tab>", "<cmd> :BufferLineCyclePrev <CR>")
  map("n", "<leader>q", ":bp|bd #<CR>")
end

M.telescope = function()
  map("n", "<C-b>", "<cmd> :Telescope buffers<CR>")
  map("n", "<C-f>", "<cmd> :Telescope find_files find_command=fd,-LH,-tf<CR>")
  map("n", "<C-s>", "<cmd> :Telescope live_grep<CR>")
  map("n", "//", "<cmd> :Telescope current_buffer_fuzzy_find <CR>")
  map("n", "<C-p>", "<cmd> :Telescope commands <CR>")
  map("n", "<space><space>", "<cmd> :Telescope command_history <CR>")
  map("n", "<leader>d", "<cmd> :Telescope lsp_definitions <CR>")
  map("n", "<leader>i", "<cmd> :Telescope lsp_implementations <CR>")
  map("n", "<leader>r", "<cmd> :Telescope lsp_references <CR>")
  map("n", "<leader>t", "<cmd> :Telescope lsp_type_definitions <CR>")
end

map("n", "<leader>z", "$zf%")

return M
