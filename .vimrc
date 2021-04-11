" vim-plug 插件
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif
call plug#begin('~/.vim/plugged')

Plug 'neoclide/coc.nvim', {'branch': 'release'}

" 主题和颜色
Plug 'w0ng/vim-hybrid'
Plug 'cormacrelf/vim-colors-github'
Plug 'lifepillar/vim-solarized8'

" EasyMotion
Plug 'easymotion/vim-easymotion'

" VimSurround
Plug 'tpope/vim-surround'

" VimRegister
Plug 'junegunn/vim-peekaboo'

" EditorCOnfig
Plug 'editorconfig/editorconfig-vim'

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
colorscheme solarized8
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

set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

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

" 当<leader> + Enter的时候取消高亮
map <silent> <leader><cr> :noh<cr>

" tl切换最近的tab
let g:lasttab = 1
nmap <leader>tl :exe "tabn ".g:lasttab<CR>
au TabLeave * let g:lasttab = tabpagenr()

" te打开新tab
map <leader>t :tabedit <C-r>=expand("%:p:h")<cr>/

" cd切换pwd到当前Buffer所在directory
map <leader>cd :cd %:p:h<cr>:pwd<cr>

" easymotion config
let g:EasyMotion_smartcase = 1
"let g:EasyMotion_startofline = 0 " keep cursor colum when JK motion
map <leader>h <Plug>(easymotion-linebackward)
map <leader>j <Plug>(easymotion-j)
map <leader>k <Plug>(easymotion-k)
map <leader>l <Plug>(easymotion-lineforward)
map <leader>. <Plug>(easymotion-repeat)
" <leader>f{char} to move to {char}
map <leader>f <Plug>(easymotion-bd-f)
nmap <leader>f <Plug>(easymotion-overwin-f)
" <leader>s{char}{char} to move to {char}{char}
nmap <leader>s <Plug>(easymotion-overwin-f2)
" " easymotion end

" Vim coc recommend config
" Use tab for trigger completion with characters ahead and navigate.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? coc#_select_confirm() :
      \ coc#expandableOrJumpable() ? "\<C-r>=coc#rpc#request('doKeymap', ['snippets-expand-jump',''])\<CR>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

let g:coc_snippet_next = '<tab>'

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current
" position. Coc only does snippet and additional edit on confirm.
" <cr> could be remapped by other vim plugin, try `:verbose imap <CR>`.

" Enter 确认 completion
if exists('*complete_info')
  inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"
else
  inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
endif

" [g和]g在提示之间移动
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" gd 跳转定义处
" gt 跳转类型定义处
" gi 跳转实现处
" gr 跳转使用处
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gt <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

" rn符号重命名
nmap <leader>rn <Plug>(coc-rename)

" fm格式化选中代码
xmap <leader>fm  <Plug>(coc-format-selected)
nmap <leader>fm <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType javascript,typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder.
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Applying codeAction to the selected region.
" ,a 执行可用的codeAction
xmap <leader>a <Plug>(coc-codeaction-selected)
nmap <leader>a <Plug>(coc-codeaction-selected)

" Map function and class text objects
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocAction('format')
" Add `:Fold` command to fold current buffer.
command! -nargs=? Fold :call     CocAction('fold', <f-args>)
" Add `:OR` command for organize imports of the current buffer.
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

let g:coc_global_extensions = ['coc-explorer', 'coc-clangd', 'coc-flutter', 'coc-html', 'coc-marketplace', 'coc-json', 'coc-git', 'coc-highlight', 'coc-pairs', 'coc-css', 'coc-eslint', 'coc-go', 'coc-lists', 'coc-markdownlint', 'coc-python', 'coc-sh', 'coc-stylelint', 'coc-snippets', 'coc-sql', 'coc-svg', 'coc-tsserver', 'coc-vetur', 'coc-yaml', 'coc-yank']

" CocMultiCursor
hi CocCursorRange guibg=#b16286 guifg=#ebdbb2

nmap <silent> <C-c> <Plug>(coc-cursors-position)
nmap <silent> <C-x> <Plug>(coc-cursors-word)
xmap <silent> <C-x> <Plug>(coc-cursors-range)
nmap <leader>x  <Plug>(coc-cursors-operator)

" coc-explorer
nmap <space>e :CocCommand explorer<CR>
