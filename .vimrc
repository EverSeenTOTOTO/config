" vim-plug 插件
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif
call plug#begin('~/.vim/plugged')

" 主题和颜色
Plug 'rakr/vim-one'

" status bar
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" EasyMotion
Plug 'easymotion/vim-easymotion'

" VimSurround
Plug 'tpope/vim-surround'

" undotree
Plug 'mbbill/undotree'

" VimRegister
Plug 'junegunn/vim-peekaboo'

" EditorCOnfig
Plug 'editorconfig/editorconfig-vim'

" tmux
Plug 'christoomey/vim-tmux-navigator'

" NERDTree
Plug 'preservim/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'ryanoasis/vim-devicons'
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'

" snippet
" Track the engine.
Plug 'SirVer/ultisnips'

" coc.nvim
Plug 'neoclide/coc.nvim', {'branch': 'release'}

call plug#end()
" 按键配置

" 核心按键
inoremap vv <esc>
let mapleader = ";"
map <space> :
map <space><leader> @

" 行号
nnoremap <F2> :set nu! nu?<CR>

" 全选
map <C-a> maggVG

" 防止缩进取消选择
vnoremap < <gv
vnoremap > >gv

" 分屏
map <up> :res +5<CR>
map <down> :res -5<CR>
map <left> :vertical resize-5<CR>
map <right> :vertical resize+5<CR>

" :W -> sudo save
command! W execute 'w !sudo tee % > /dev/null' <bar> edit!

" 折行
nnoremap k gk
nnoremap gk k
nnoremap j gj
nnoremap gj j

nnoremap <silent> n nzz
nnoremap <silent> N Nzz
nnoremap <silent> * *zz
nnoremap <silent> # #zz
nnoremap <silent> g* g*zz

vnoremap H ^
vnoremap L $
nnoremap H ^
nnoremap L $
nnoremap U <C-r>

" Alt + jk移动行
execute "set <M-j>=\ej"
execute "set <M-k>=\ek"
execute "set <M-l>=\el"
execute "set <M-h>=\eh"
nmap <M-j> mz:m+<cr>`z
imap <M-j> <esc>mz:m+<cr>`zi
vmap <M-j> :m'>+<cr>`<my`>mzgv`yo`z
imap <M-k> <esc>mz:m-2<cr>`zi
nmap <M-k> mz:m-2<cr>`z
vmap <M-k> :m'<-2<cr>`>my`<mzgv`yo`z

" leader + /的时候取消高亮
map <silent> <leader>/ :noh<cr>

" leader + tl切换tab last
let g:lasttab = 1
nmap <leader>tl :exe "tabn ".g:lasttab<CR>
au TabLeave * let g:lasttab = tabpagenr()

" cd切换pwd到当前Buffer所在directory
map <leader>cd :cd %:p:h<cr>:pwd<cr>

" copy to clipboard
vnoremap <silent>y "yy <Bar> :call system('xclip -i -sel c', @y)<CR>

" 设置
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
nnoremap <F5> :UndotreeToggle<CR>

set completeopt=popup,preview,menuone

" 不与vi兼容
set nocompatible

" 历史文件行数
set history=500

" 文件变更时自动更新
set autoread
au FocusGained,BufEnter * checktime

" Set 7 lines to the cursor - when moving vertically using j/k
set so=7

" Avoid garbled characters in Chinese language windows OS
let $LANG='en'
set langmenu=en
source $VIMRUNTIME/delmenu.vim
source $VIMRUNTIME/menu.vim

" Turn on the Wild menu
set wildmenu
set wildignore=*.o,*~,*.pyc
if has("win16") || has("win32")
    set wildignore+=.git\*,.hg\*,.svn\*
else
    set wildignore+=*/.git/*,*/.hg/*,*/.svn/*,*/.DS_Store
endif

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
set t_vb=
set tm=500
" Properly disable sound on errors on MacVim
if has("gui_macvim")
    autocmd GUIEnter * set vb t_vb=
endif

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
" Be smart when using tabs ;)
set smarttab
" 1 tab == 2 spaces
set shiftwidth=2
set tabstop=2

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

" 主题背景
"Credit joshdick
"Use 24-bit (true-color) mode in Vim/Neovim when outside tmux.
"If you're using tmux version 2.2 or later, you can remove the outermost $TMUX check and use tmux's 24-bit color support
"(see < http://sunaku.github.io/tmux-24bit-color.html#usage > for more information.)
if (has("nvim"))
  "For Neovim 0.1.3 and 0.1.4 < https://github.com/neovim/neovim/pull/2198 >
  let $NVIM_TUI_ENABLE_TRUE_COLOR=1
endif
"For Neovim > 0.1.5 and Vim > patch 7.4.1799 < https://github.com/vim/vim/commit/61be73bb0f965a895bfb064ea3e55476ac175162 >
"Based on Vim patch 7.4.1770 (`guicolors` option) < https://github.com/vim/vim/commit/8a633e3427b47286869aa4b96f2bfc1fe65b25cd >
" < https://github.com/neovim/neovim/wiki/Following-HEAD#20160511 >
if (has("termguicolors"))
  set termguicolors
endif

set background=light        " for the light version
let g:one_allow_italics = 1 " I love italic for comments
colorscheme one

" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=300
" Don't pass messages to |ins-completion-menu|.
set shortmess+=c
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

" 自动添加标题头
fun! AutoSetFileHead()
    let filetype_name = strpart(expand("%"), stridx(expand("%"), "."))
    " .sh "
    if filetype_name == '.sh'
        call setline(1, "\#!/bin/bash")
    endif

    " python "
    if filetype_name == '.py'
        call setline(1, "\#!/usr/bin/env python")
        call append(1, "\# encoding: utf-8")
    endif

    " zx "
    if filetype_name == '.mjs'
        call setline(1, "\#!/usr/bin/env zx")
    endif

    " js "
    if filetype_name == '.js'
        call setline(1, "\"use strict\"")
    endif

    normal G
    normal o
    normal o
endfunc
if has("autocmd")
  autocmd BufNewFile *.sh,*.py,*.mjs :call AutoSetFileHead()
endif

" 插件配置

" easymotion config
let g:EasyMotion_smartcase = 1

"let g:EasyMotion_startofline = 0 " keep cursor colum when JK motion
map <leader>a <Plug>(easymotion-linebackward)
map <leader>s <Plug>(easymotion-j)
map <leader>w <Plug>(easymotion-k)
map <leader>d <Plug>(easymotion-lineforward)
map <leader>. <Plug>(easymotion-repeat)
" <leader>f{char} to move to {char}
map <leader>f <Plug>(easymotion-bd-f)
nmap <leader>f <Plug>(easymotion-overwin-f)
nmap <leader>z <Plug>(easymotion-overwin-f2)
" easymotion end

" Airline
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1

" NERDTree
nnoremap <C-t> :NERDTreeToggle<CR>
nnoremap <C-f> :NERDTreeFind<CR>
" Start NERDTree when Vim starts with a directory argument.
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists('s:std_in') |
    \ execute 'NERDTree' argv()[0] | wincmd p | enew | execute 'cd '.argv()[0] | endif
" open the existing nerdtree on each new tab.
" autocmd bufwinenter * if getcmdwintype() == '' | silent nerdtreemirror | endif

" NERDTree git plugin
let g:NERDTreeGitStatusUseNerdFonts = 1

" UltiSnips
let g:UltiSnipsSnippetDirectories=[$HOME.'/.vim/UltiSnips']
let g:UltiSnipsExpandTrigger="<c-j>"
let g:UltiSnipsJumpForwardTrigger="<c-j>"
let g:UltiSnipsJumpBackwardTrigger="<c-k>"

" If you want :UltiSnipsEdit to split your window.
let g:UltiSnipsEditSplit="vertical"

" coc-nvim

" use <tab> for trigger completion and navigate to the next complete item
function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~ '\s'
endfunction

inoremap <silent><expr> <Tab>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<Tab>" :
      \ coc#refresh()

" use <tab> to navigate the completion list
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

" confirm with enter
inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

nmap <leader>gd <Plug>(coc-definition)
nmap <leader>gt <Plug>(coc-type-definition)
nmap <leader>gi <Plug>(coc-implementation)
nmap <leader>gr <Plug>(coc-references)
xmap <leader>gf  <Plug>(coc-format-selected)
nmap <leader>gf  <Plug>(coc-format-selected)
nmap <leader>gn <Plug>(coc-rename)+
xmap <leader>ga  <Plug>(coc-codeaction-selected)
nmap <leader>ga  <Plug>(coc-codeaction-selected)

xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

" global extensions
let g:coc_global_extensions = [
      \'coc-css',
      \'coc-eslint',
      \'coc-git',
      \'coc-html',
      \'coc-json',
      \'coc-lists',
      \'coc-markdownlint',
      \'coc-python',
      \'coc-stylelint',
      \'coc-tabnine',
      \'coc-tsserver',
      \'coc-vetur',
      \'coc-yaml',
      \]

" multi-cursor
nmap <silent> <C-n> <Plug>(coc-cursors-word)*
xmap <silent> <C-n> y/\V<C-r>=escape(@",'/\')<CR><CR>gN<Plug>(coc-cursors-range)gn

nnoremap <C-l> :CocList<CR>
