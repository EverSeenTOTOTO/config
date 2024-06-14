local opt = vim.opt

opt.encoding = "utf-8"
opt.backspace = "indent,eol,start"
opt.clipboard = "unnamedplus"
opt.cmdheight = 1
opt.confirm = true
opt.cul = true -- cursor line
opt.laststatus = 3 -- global statusline
opt.lazyredraw = true
opt.title = true

opt.completeopt = { "menu", "menuone", "noselect" }
opt.copyindent = true
opt.cursorline = true
opt.conceallevel = 2
opt.confirm = true

-- Indentline
opt.expandtab = true
opt.preserveindent = true
opt.shiftwidth = 2
opt.smartindent = true

opt.showmode = false
opt.pumblend = 10 -- Popup blend
opt.pumheight = 10
opt.scrolloff = 4
opt.sidescrolloff = 8

opt.fillchars = {
	diff = "╱", -- alternatives = ⣿ ░ ─
	eob = " ", -- suppress ~ at EndOfBuffer
	fold = " ",
	foldclose = "▸",
	foldopen = "▾",
	foldsep = "│",
	horiz = "━",
	horizdown = "┳",
	horizup = "┻",
	msgsep = "‾",
	vert = "┃",
	verthoriz = "╋",
	vertleft = "┫",
	vertright = "┣",
}

opt.wildignore = {
	"*.*~,*~",
	"*.ai,*.bmp,*.gif,*.ico,*.jpg,*.jpeg,*.png,*.psd,*.webp",
	"*.aux,*.out,*.toc",
	"*.avi,*.m4a,*.mp3,*.oga,*.ogg,*.wav,*.webm",
	"*.doc,*.pdf",
	"*.eot,*.otf,*.ttf,*.woff",
	".git,.svn",
	"*.o,*.obj,*.dll,*.jar,*.pyc,__pycache__,*.rbc,*.class",
	"*.swp,.lock,.DS_Store,._*,tags.lock",
	"*.zip,*.tar.gz,*.tar.bz2,*.rar,*.tar.xz",
}

opt.grepformat = "%f:%l:%c:%m"
opt.grepprg = "rg --vimgrep"

opt.hidden = true
opt.ignorecase = true
opt.mouse = "a"
opt.smartcase = true

-- Numbers
opt.number = true
opt.numberwidth = 2
opt.relativenumber = false
opt.ruler = false

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

opt.list = true
opt.listchars = {
	space = nil,
	eol = nil,
	tab = "│ ",
	extends = "›", -- Alternatives: … »
	precedes = "‹", -- Alternatives: … «
	trail = "•", -- BULLET (U+2022, UTF-8: E2 80 A2)
}

opt.signcolumn = "yes"
opt.splitbelow = true
opt.splitright = true
opt.splitkeep = "screen"
opt.tabstop = 2
opt.termguicolors = true
opt.timeoutlen = 400
opt.undofile = true

-- interval for writing swap file to disk, also used by gitsigns
opt.updatetime = 300
opt.swapfile = false
opt.writebackup = false
opt.winminwidth = 5 -- Minimum window width
opt.virtualedit = "block" -- Allow cursor to move where there is no text in visual block mode

-- go to previous/next line with h,l,left arrow and right arrow
-- when cursor reaches end/beginning of line
opt.whichwrap:append("<>[]hl")

opt.wrap = true

-- theme
vim.cmd("highlight clear")
if vim.fn.exists("syntax_on") then
	vim.cmd("syntax reset")
end

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
	vim.g["loaded_" .. plugin] = 1
end

vim.schedule(function()
	vim.opt.shadafile = vim.fn.expand("$HOME") .. "/.local/share/nvim/shada/main.shada"
	vim.cmd([[ silent! rsh ]])
end)

-- disable providers
vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- neovide
if vim.g.neovide then
	vim.o.guifont = "FiraCode Nerd Font:h14"
	vim.g.neovide_scale_factor = 1.0
	vim.g.neovide_transparency = 0.95
	vim.g.neovide_cursor_vfx_mode = "sonicboom"
end

if vim.fn.has("nvim-0.10") == 1 then
	opt.smoothscroll = true
end

vim.g.markdown_recommended_style = 0
