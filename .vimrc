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

au FocusGained,BufEnter * checktime
au Filetype markdown,python setl ts=4 sw=4 sts=4

set autoread
set backspace=eol,start,indent
set foldcolumn=1
set grepprg=rg\ --vimgrep\ --smart-case\ --follow
set history=500
set hlsearch
set incsearch
set lazyredraw
set magic
set mat=2
set nocompatible
set noerrorbells
set novisualbell
set ruler
set showmatch
set smartcase
set so=7
set tm=500
set whichwrap+=<,>,h,l

syntax enable

if $COLORTERM == 'gnome-terminal'
    set t_Co=256
endif

if has("gui_running")
    set guioptions-=T
    set guioptions-=e
    set t_Co=256
    set guitablabel=%M\ %t
endif

set encoding=utf8
set expandtab
set ffs=unix,dos,mac
set lbr
set nobackup
set noswapfile
set nowb
set shiftwidth=2
set si "Smart indent
set smarttab
set softtabstop=2
set tabstop=2
set tw=500
set wrap "Wrap lines

try
  set switchbuf=useopen,usetab,newtab
  set stal=2
catch
endtry

set cmdheight=2
set completeopt=popup,preview,menuone
set hidden

execute "set <M-h>=\eh"
execute "set <M-j>=\ej"
execute "set <M-k>=\ek"
execute "set <M-l>=\el"

if has("termguicolors")
  set termguicolors
endif

set background=dark
set shm+=cI
set updatetime=300

if has("patch-8.1.1564")
  " Recently vim can merge signcolumn and number column into one
  set signcolumn=number
else
  set signcolumn=yes
endif

set laststatus=2

filetype plugin on
filetype indent on

let mapleader = ","

inoremap vv <esc>
map <leader><leader> @
map <space> :

nnoremap <F2> :set nu! nu?<CR>

vnoremap < <gv
vnoremap > >gv

map <up> :res +5<CR>
map <down> :res -5<CR>
map <left> :vertical resize-5<CR>
map <right> :vertical resize+5<CR>
map d<up> :wincmd k<cr>:wincmd c<cr>:wincmd p<cr>
map d<down> :wincmd j<cr>:wincmd c<cr>:wincmd p<cr>
map d<left> :wincmd h<cr>:wincmd c<cr>:wincmd p<cr>
map d<right> :wincmd l<cr>:wincmd c<cr>:wincmd p<cr>

nnoremap k gk
nnoremap gk k
nnoremap j gj
nnoremap gj j

nnoremap <silent> n nzz
nnoremap <silent> N Nzz
nnoremap <silent> * *zz
nnoremap <silent> # #zz
nnoremap <silent> g* g*zz

vnoremap H g^
vnoremap L g$
nnoremap H g^
nnoremap L g$
nnoremap U <C-r>

nmap <M-j> mz:m+<cr>`z
imap <M-j> <esc>mz:m+<cr>`zi
vmap <M-j> :m'>+<cr>`<my`>mzgv`yo`z
imap <M-k> <esc>mz:m-2<cr>`zi
nmap <M-k> mz:m-2<cr>`z
vmap <M-k> :m'<-2<cr>`>my`<mzgv`yo`z

vnoremap p p:let @+=@0<CR>

imap <C-a> <Home>
imap <C-b> <esc>bi
imap <C-e> <End>
imap <C-f> <esc>ea
imap <C-h> <Left>
imap <C-j> <Down>
imap <C-k> <Up>
imap <C-l> <Right>
imap <C-o> <esc>O

nmap <leader>m :make start ;read<cr>
nmap <leader>z $zf%
