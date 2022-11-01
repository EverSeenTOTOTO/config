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
opt.clipboard = "unnamedplus"
opt.cmdheight = 1
opt.cul = true -- cursor line
opt.lazyredraw = true

opt.completeopt = "menu,menu,menuone,noselect"
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

opt.fillchars = {
  fold = " ",
  eob = " ", -- suppress ~ at EndOfBuffer
  diff = "╱", -- alternatives = ⣿ ░ ─
  msgsep = "‾",
  foldopen = "▾",
  foldsep = "│",
  foldclose = "▸",
  horiz = "━",
  horizup = "┻",
  horizdown = "┳",
  vert = "┃",
  vertleft = "┫",
  vertright = "┣",
  verthoriz = "╋",
}

opt.wildignore = {
  "*.aux,*.out,*.toc",
  "*.o,*.obj,*.dll,*.jar,*.pyc,__pycache__,*.rbc,*.class",
  -- media
  "*.ai,*.bmp,*.gif,*.ico,*.jpg,*.jpeg,*.png,*.psd,*.webp",
  "*.avi,*.m4a,*.mp3,*.oga,*.ogg,*.wav,*.webm",
  "*.eot,*.otf,*.ttf,*.woff",
  "*.doc,*.pdf",
  -- archives
  "*.zip,*.tar.gz,*.tar.bz2,*.rar,*.tar.xz",
  -- temp/system
  "*.*~,*~ ",
  "*.swp,.lock,.DS_Store,._*,tags.lock",
  -- version control
  ".git,.svn",
}

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
opt.shortmess = {
  t = true, -- truncate file messages at start
  A = true, -- ignore annoying swap file messages
  o = true, -- file-read message overwrites previous
  O = true, -- file-read message overwrites previous
  T = true, -- truncate non-file messages in middle
  f = true, -- (file x of x) instead of just (x of x
  F = true, -- Don't give file info when editing a file, NOTE: this breaks autocommand messages
  s = true,
  c = true,
  W = true, -- Don't show [w] or written when writing
}
opt.formatoptions = {
  ["1"] = true,
  ["2"] = true, -- Use indent from 2nd line of a paragraph
  q = true, -- continue comments with gq"
  c = true, -- Auto-wrap comments using textwidth
  r = true, -- Continue comments when pressing Enter
  n = true, -- Recognize numbered lists
  t = false, -- autowrap lines using text width value
  j = true, -- remove a comment leader when joining lines.
  -- Only break if the line was not longer than 'textwidth' when the insert
  -- started and only at a white character that has been entered during the
  -- current insert command.
  l = true,
  v = true,
}
opt.listchars = {
  eol = nil,
  tab = "│ ",
  extends = "›", -- Alternatives: … »
  precedes = "‹", -- Alternatives: … «
  trail = "•", -- BULLET (U+2022, UTF-8: E2 80 A2)
}

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
