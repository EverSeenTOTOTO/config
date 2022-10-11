local opt = vim.opt
local g = vim.g

-- disable providers
g.loaded_perl_provider = 0
g.loaded_ruby_provider = 0
g.loaded_node_provider = 0
g.loaded_python3_provider = 0

opt.confirm = true
opt.laststatus = 3 -- global statusline
opt.title = true
-- opt.clipboard = "unnamedplus"
opt.cmdheight = 1
opt.cul = true -- cursor line
opt.lazyredraw = true

opt.completeopt = "menuone,noselect"
opt.copyindent = true
opt.cursorline = true

-- Indentline
opt.expandtab = true
opt.shiftwidth = 2
opt.smartindent = true
opt.preserveindent = true

opt.pumheight = 10
opt.scrolloff = 8
opt.sidescrolloff = 8
opt.showmode = false

-- disable tilde on end of buffer: https://github.com/neovim/neovim/pull/8546#issuecomment-643643758
opt.fillchars = { eob = " " }

opt.hidden = true
opt.ignorecase = true
opt.smartcase = true
opt.mouse = "a"

-- Numbers
opt.number = true
opt.numberwidth = 2
opt.relativenumber = false
opt.ruler = false

-- disable nvim intro
opt.shortmess:append "sI"

opt.signcolumn = "yes"
opt.splitbelow = true
opt.splitright = true
opt.tabstop = 2
opt.termguicolors = true
opt.timeoutlen = 400
opt.undofile = true

-- interval for writing swap file to disk, also used by gitsigns
opt.updatetime = 250
opt.swapfile = false
opt.writebackup = false

-- go to previous/next line with h,l,left arrow and right arrow
-- when cursor reaches end/beginning of line
opt.whichwrap:append "<>[]hl"

opt.wrap = true

-- theme
vim.cmd "highlight clear"
if vim.fn.exists "syntax_on" then
  vim.cmd "syntax reset"
end

vim.cmd "colorscheme iceberg"

-- disable some builtin vim plugins

local default_plugins = {
  "black",
  "2html_plugin",
  "getscript",
  "getscriptPlugin",
  "gzip",
  "logipat",
  "netrw",
  "netrwPlugin",
  "netrwSettings",
  "netrwFileHandlers",
  "matchit",
  "tar",
  "tarPlugin",
  "rrhelper",
  "spellfile_plugin",
  "vimball",
  "vimballPlugin",
  "zip",
  "zipPlugin",
}

for _, plugin in pairs(default_plugins) do
  g["loaded_" .. plugin] = 1
end

vim.schedule(function()
  vim.opt.shadafile = vim.fn.expand "$HOME" .. "/.local/share/nvim/shada/main.shada"
  vim.cmd [[ silent! rsh ]]
end)
