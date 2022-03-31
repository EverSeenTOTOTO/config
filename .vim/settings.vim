" mark on leave
au BufLeave * mark L

" undo
if has("persistent_undo")
   let target_path = expand('~/.undodir')

    " create the directory and any parent directories
    " if the location does not exist.
    if !isdirectory(target_path)
        call mkdir(target_path, "p", 0700)
    endif

    let &undodir=target_path
    set undofile
endif

" 不与vi兼容
set nocompatible

" 历史文件行数
set history=500

" 文件变更时自动更新
set autoread
au FocusGained,BufEnter * checktime

" grep -> rg
set grepprg=rg\ --vimgrep\ --smart-case\ --follow

" Set 7 lines to the cursor - when moving vertically using j/k
set so=7

"Always show current position
set ruler

" Configure backspace so it acts as it should act
set backspace=eol,start,indent
set whichwrap+=<,>,h,l

" search忽略大小写
" set ignorecase
" search smart case
set smartcase

" 高亮搜索结果
set hlsearch
" Makes search act like search in modern browsers
set incsearch
" Don't redraw while executing macros (good performance config)
set lazyredraw

" 正则magic
set magic
" 展示匹配的括号
set showmatch
" How many tenths of a second to blink when matching brackets
set mat=2
" 静音
set noerrorbells
set novisualbell
set tm=500

" Add a bit extra margin to the left
set foldcolumn=1

" 语法高亮
syntax enable
" Enable 256 colors palette in Gnome Terminal
if $COLORTERM == 'gnome-terminal'
    set t_Co=256
endif
" Set extra options when running in GUI mode
if has("gui_running")
    set guioptions-=T
    set guioptions-=e
    set t_Co=256
    set guitablabel=%M\ %t
endif

" utf8编码
set encoding=utf8
" unix 文件类型
set ffs=unix,dos,mac
" 禁用备份
set nobackup
set nowb
set noswapfile
" tab使用空格
set expandtab
" Be smart when using tabs
set smarttab
" 1 tab == 2 spaces
set shiftwidth=2
set softtabstop=2
set tabstop=2

au Filetype cpp,markdown,rust,go,python setl ts=4 sw=4 sts=4

" 超过500个字符折行
set lbr
set tw=500
set ai "Auto indent
set si "Smart indent
set wrap "Wrap lines
" Specify the behavior when switching between buffers
try
  set switchbuf=useopen,usetab,newtab
  set stal=2
catch
endtry

" TextEdit might fail if hidden is not set.
set hidden
" Give more space for displaying messages.
set cmdheight=2

if has("nvim")
  "For Neovim 0.1.3 and 0.1.4 < https://github.com/neovim/neovim/pull/2198 >
  let $NVIM_TUI_ENABLE_TRUE_COLOR=1
else 
  set completeopt=popup,preview,menuone
  execute "set <M-j>=\ej"
  execute "set <M-k>=\ek"
  execute "set <M-l>=\el"
  execute "set <M-h>=\eh"
endif

if has("termguicolors")
  set termguicolors
endif

" theme
set background=dark
colorscheme iceberg

" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=300
" Don't pass messages to |ins-completion-menu|.
set shm+=cI
" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
if has("patch-8.1.1564")
  " Recently vim can merge signcolumn and number column into one
  set signcolumn=number
else
  set signcolumn=yes
endif

" 始终显示状态栏
set laststatus=2

" 打开文件时跳转到上次所在位置
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

" Enable filetype plugins
filetype plugin on
filetype indent on

au BufNewFile *.sh,*.py,*.mjs :call AutoSetFileHead()
