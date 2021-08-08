" vim-plug 插件
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif
call plug#begin('~/.vim/plugged')

" 主题和颜色
Plug 'w0ng/vim-hybrid'
Plug 'cormacrelf/vim-colors-github'

" status bar
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" multi cursor
" Plug 'terryma/vim-multiple-cursors'
Plug 'mg979/vim-visual-multi', {'branch': 'master'}

" EasyMotion
Plug 'easymotion/vim-easymotion'

" VimSurround
Plug 'tpope/vim-surround'

" VimRegister
Plug 'junegunn/vim-peekaboo'

" EditorCOnfig
Plug 'editorconfig/editorconfig-vim'

" NERDTree
Plug 'preservim/nerdtree'

Plug 'preservim/nerdcommenter'

call plug#end()

" esc -> vv
inoremap vv <esc>
" <leader>
let mapleader = ";"
" space -> :
map <space> :
" space space -> @
map <space><space> @

" undo
set undodir=~/.vim/undo
set undofile
" 相对行号
set relativenumber number
" 历史行数
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
set ignorecase
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
" use a slightly darker background, like GitHub inline code blocks
let g:github_colors_soft = 1
" 主题背景
set background=light
colorscheme github
call github_colors#togglebg_map('<f5>')

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

" 保存文件时删除trailing white space
fun! CleanExtraSpaces()
    let save_cursor = getpos(".")
    let old_query = getreg('/')
    silent! %s/\s\+$//e
    call setpos('.', save_cursor)
    call setreg('/', old_query)
endfun

if has("autocmd")
    autocmd BufWritePre *.txt,*.js,*.py,*.wiki,*.sh,*.coffee :call CleanExtraSpaces()
endif

" Enable filetype plugins
filetype plugin on
filetype indent on

" 替换方向键为调节分屏大小
map <up> :res +5<CR>
map <down> :res -5<CR>
map <left> :vertical resize-5<CR>
map <right> :vertical resize+5<CR>

" force save
nmap <leader>W :w!<cr>

" :W -> sudo save
command! W execute 'w !sudo tee % > /dev/null' <bar> edit!

" Ctrl + jk移动行
nmap <C-j> mz:m+<cr>`z
imap <C-j> <esc>mz:m+<cr>`zi
vmap <C-j> :m'>+<cr>`<my`>mzgv`yo`z
imap <C-k> <esc>mz:m-2<cr>`zi
nmap <C-k> mz:m-2<cr>`z
vmap <C-k> :m'<-2<cr>`>my`<mzgv`yo`z

" leader + Enter的时候取消高亮
map <silent> <leader><cr> :noh<cr>

" leader + tl切换最近的tab
let g:lasttab = 1
nmap <leader>tl :exe "tabn ".g:lasttab<CR>
au TabLeave * let g:lasttab = tabpagenr()

" leader + te打开新tab
map <leader>t :tabedit <C-r>=expand("%:p:h")<cr>/

" cd切换pwd到当前Buffer所在directory
map <leader>cd :cd %:p:h<cr>:pwd<cr>

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
let g:airline#extensions#tabline#enabled = 1

" NERDTree
nnoremap <leader>n :NERDTreeFocus<CR>
nnoremap <C-n> :NERDTree<CR>
nnoremap <C-t> :NERDTreeToggle<CR>
nnoremap <C-f> :NERDTreeFind<CR>
" Start NERDTree when Vim starts with a directory argument.
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists('s:std_in') |
    \ execute 'NERDTree' argv()[0] | wincmd p | enew | execute 'cd '.argv()[0] | endif

" NERDComment
" Create default mappings
let g:NERDCreateDefaultMappings = 1
" Add spaces after comment delimiters by default
let g:NERDSpaceDelims = 1
" Use compact syntax for prettified multi-line comments
let g:NERDCompactSexyComs = 1
" Align line-wise comment delimiters flush left instead of following code indentation
let g:NERDDefaultAlign = 'left'
" Set a language to use its alternate delimiters by default
let g:NERDAltDelims_javascript = 1
" Add your own custom formats or override the defaults
let g:NERDCustomDelimiters = { 'c': { 'left': '/**','right': '*/' } }
" Allow commenting and inverting empty lines (useful when commenting a region)
let g:NERDCommentEmptyLines = 1
" Enable trimming of trailing whitespace when uncommenting
let g:NERDTrimTrailingWhitespace = 1
" Enable NERDCommenterToggle to check all selected lines is commented or not 
let g:NERDToggleCheckAllLines = 1
