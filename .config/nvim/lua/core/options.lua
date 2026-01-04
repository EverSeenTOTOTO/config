local opt = vim.opt

-- General Settings
opt.encoding = 'utf-8' -- Set default encoding
opt.backspace = 'indent,eol,start' -- Make backspace work as expected
opt.hidden = true -- Enable background buffers
opt.mouse = 'a' -- Enable mouse in all modes
opt.timeoutlen = 400 -- Time to wait for a mapped sequence to complete (in milliseconds)

-- UI Settings
opt.cmdheight = 1 -- Command line height
opt.confirm = true -- Ask for confirmation instead of erroring
opt.cursorline = true -- Highlight current line
opt.laststatus = 3 -- Global statusline
opt.showmode = false -- Don't show mode in command line
opt.signcolumn = 'yes' -- Always show sign column
opt.title = true -- Set window title

-- Numbers
opt.number = true -- Show line numbers
opt.numberwidth = 2 -- Width of line number column
opt.relativenumber = false -- Disable relative line numbers
opt.ruler = false -- Hide ruler

-- Indentation and Formatting
opt.expandtab = true -- Use spaces instead of tabs
opt.preserveindent = true -- Preserve indent structure when reindenting
opt.shiftwidth = 2 -- Number of spaces for each indentation level
opt.smartindent = true -- Smart autoindenting when starting a new line
opt.tabstop = 2 -- Number of spaces that a <Tab> counts for
opt.softtabstop = 2 -- Number of spaces that a <Tab> counts for while editing
opt.copyindent = true -- Copy indent from current line when starting a new line

opt.showmode = false
opt.pumblend = 10 -- Popup blend
opt.pumheight = 10
opt.scrolloff = 4
opt.sidescrolloff = 8

opt.fillchars = {
  diff = '╱', -- alternatives = ⣿ ░ ─
  eob = ' ', -- suppress ~ at EndOfBuffer
  fold = ' ',
  foldclose = '▸',
  foldopen = '▾',
  foldsep = '│',
  horiz = '━',
  horizdown = '┳',
  horizup = '┻',
  msgsep = '‾',
  vert = '┃',
  verthoriz = '╋',
  vertleft = '┫',
  vertright = '┣',
}

opt.wildignore = {
  '*.*~,*~',
  '*.ai,*.bmp,*.gif,*.ico,*.jpg,*.jpeg,*.png,*.psd,*.webp',
  '*.aux,*.out,*.toc',
  '*.avi,*.m4a,*.mp3,*.oga,*.ogg,*.wav,*.webm',
  '*.doc,*.pdf',
  '*.eot,*.otf,*.ttf,*.woff',
  '.git,.svn',
  '*.o,*.obj,*.dll,*.jar,*.pyc,__pycache__,*.rbc,*.class',
  '*.swp,.lock,.DS_Store,._*,tags.lock',
  '*.zip,*.tar.gz,*.tar.bz2,*.rar,*.tar.xz',
}

opt.grepformat = '%f:%l:%c:%m'
opt.grepprg = 'rg --vimgrep'

opt.ignorecase = true
opt.smartcase = true

opt.shortmess = {
  t = true, -- truncate file messages at start
  A = true, -- ignore annoying swap file messages
  o = true, -- file-read message overwrites previous
  O = true, -- file-read message overwrites previous
  T = true, -- truncate non-file messages in middle
  f = true, -- (file x of x) instead of just (x of x
  F = true, -- Don't give file info when editing a file, NOTE: this breaks autocommand messages
  s = true, -- don't give "search hit BOTTOM, continuing at TOP" message
  c = true, -- don't give |ins-completion-menu| messages
  W = true, -- Don't show [w] or written when writing
}
opt.formatoptions = {
  ['1'] = true,
  ['2'] = true, -- Use indent from 2nd line of a paragraph
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
  tab = '│ ',
  extends = '›', -- Alternatives: … »
  precedes = '‹', -- Alternatives: … «
  trail = '•', -- BULLET (U+2022, UTF-8: E2 80 A2)
}

opt.signcolumn = 'yes'
opt.splitbelow = true
opt.splitright = true
opt.splitkeep = 'screen'
opt.tabstop = 2
opt.termguicolors = true
opt.timeoutlen = 400
opt.undofile = true

opt.undofile = true -- Enable persistent undo
opt.updatetime = 300
opt.swapfile = false -- Disable swap files
opt.writebackup = false -- Disable backup files
opt.winminwidth = 5 -- Minimum window width
opt.virtualedit = 'block' -- Allow cursor to move where there is no text in visual block mode

-- go to previous/next line with h,l,left arrow and right arrow
-- when cursor reaches end/beginning of line
opt.whichwrap:append('<>[]hl')

opt.wrap = true

-- Fold options
local default_foldopen = vim.opt.foldopen:get()
if vim.tbl_contains(default_foldopen, 'block') then vim.opt.foldopen:remove('block') end
vim.opt.foldlevelstart = 99 -- Start with all folds open
vim.o.foldcolumn = '1' -- '0' is not bad
vim.o.foldlevel = 99 -- feel free to decrease the value
vim.o.foldenable = true
vim.o.foldmethod = 'expr'
vim.o.foldexpr = 'v:lua.vim.treesitter.foldexpr()'

-- disable some builtin vim plugins

local default_plugins = {
  '2html_plugin',
  'gzip',
  'netrw',
  'netrwPlugin',
  'netrwSettings',
  'netrwFileHandlers',
  'matchit',
  'tar',
  'tarPlugin',
  'spellfile_plugin',
  'zip',
  'zipPlugin',
}

for _, plugin in pairs(default_plugins) do
  vim.g['loaded_' .. plugin] = 1
end

vim.schedule(function()
  vim.opt.shadafile = vim.fn.expand('$HOME') .. '/.local/share/nvim/shada/main.shada'
  vim.cmd([[ silent! rsh ]])
end)

-- disable providers
vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0

-- neovide
---@diagnostic disable-next-line: undefined-field
if vim.g.neovide then
  vim.o.guifont = 'FiraCode Nerd Font:h14'
  vim.g.neovide_scale_factor = 1.0
  vim.g.neovide_transparency = 0.95
  vim.g.neovide_cursor_vfx_mode = 'sonicboom'
end

opt.smoothscroll = true

vim.g.markdown_recommended_style = 0

-- clipboard
local function setup_clipboard()
  local has_mac = vim.fn.has('mac') == 1
  local has_wsl = vim.fn.has('wsl') == 1 or vim.fn.executable('clip.exe') == 1
  local has_x11 = vim.env.DISPLAY ~= nil and vim.fn.executable('xclip') == 1
  local has_wayland = vim.env.WAYLAND_DISPLAY ~= nil and vim.fn.executable('wl-copy') == 1
  local has_tmux = vim.env.TMUX ~= nil

  local has_external_clipboard = has_mac or has_wsl or has_x11 or has_wayland

  -- 如果没有外部工具，使用 nvim 默认剪贴板
  if not has_external_clipboard then
    vim.opt.clipboard = 'unnamedplus'
    return
  end

  vim.g.clipboard = {
    name = 'custom',
    copy = {
      ['+'] = function(lines)
        local text = table.concat(lines, '\n')

        -- 复制到系统剪贴板
        if has_mac then
          vim.fn.system('pbcopy', text)
        elseif has_wayland then
          vim.fn.system('wl-copy', text)
        elseif has_x11 then
          vim.fn.system('xclip -i -sel c', text)
        elseif has_wsl then
          vim.fn.system('clip.exe', text)
        end

        -- 同步到 tmux
        if has_tmux then vim.fn.system('tmux set-buffer -- ' .. vim.fn.shellescape(text)) end
      end,
      ['*'] = function(lines) vim.g.clipboard.copy['+'](lines) end,
    },
    paste = {
      ['+'] = function()
        local text = ''
        if has_mac then
          text = vim.fn.system('reattach-to-user-namespace pbpaste')
        elseif has_wayland then
          text = vim.fn.system('wl-paste --no-newline')
        elseif has_x11 then
          text = vim.fn.system('xclip -o -sel c')
        elseif has_wsl then
          -- 使用 powershell.exe 并去除 Windows 换行符
          text = vim.fn.system('powershell.exe -NoProfile -Command "Get-Clipboard"')
          -- 去除 ^M (CR) 字符
          text = text:gsub('\r\n', '\n'):gsub('\r', '')
        end

        -- ssh session
        if has_tmux and vim.env.XDG_SESSION_TYPE == 'tty' then text = vim.fn.system('tmux show-buffer') end

        return vim.split(text, '\n')
      end,
      ['*'] = function() return vim.g.clipboard.paste['+']() end,
    },
    cache_enabled = 0,
  }

  vim.opt.clipboard = 'unnamedplus'
end

setup_clipboard()
