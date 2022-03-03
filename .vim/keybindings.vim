inoremap vv <esc>
let mapleader = ","
map <leader><leader> @
map <space> :

" 行号
nnoremap <F2> :set nu! nu?<CR>

" 防止缩进取消选择
vnoremap < <gv
vnoremap > >gv

" 分屏
map <up> :res +5<CR>
map <down> :res -5<CR>
map <left> :vertical resize-5<CR>
map <right> :vertical resize+5<CR>
map d<up> :wincmd k<cr>:wincmd c<cr>:wincmd p<cr>
map d<down> :wincmd j<cr>:wincmd c<cr>:wincmd p<cr>
map d<left> :wincmd h<cr>:wincmd c<cr>:wincmd p<cr>
map d<right> :wincmd l<cr>:wincmd c<cr>:wincmd p<cr>

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

vnoremap H g^
vnoremap L g$
nnoremap H g^
nnoremap L g$
nnoremap U <C-r>

" Alt + jk移动行
nmap <M-j> mz:m+<cr>`z
imap <M-j> <esc>mz:m+<cr>`zi
vmap <M-j> :m'>+<cr>`<my`>mzgv`yo`z
imap <M-k> <esc>mz:m-2<cr>`zi
nmap <M-k> mz:m-2<cr>`z
vmap <M-k> :m'<-2<cr>`>my`<mzgv`yo`z

" leader + /的时候取消高亮
nmap <leader>/ :noh<cr>:diffupdate<cr>:syntax sync fromstart<cr><c-l>

" visual select search
fun! s:GetSelectedText()
  let l:old_reg = getreg('"')
  let l:old_regtype = getregtype('"')
  norm gvy
  let l:ret = getreg('"')
  call setreg('"', l:old_reg, l:old_regtype)
  exe "norm \<Esc>"
  return l:ret
endfunc

vnoremap <silent> * :call setreg("/",
    \ substitute(<SID>GetSelectedText(),
    \ '\_s\+',
    \ '\\_s\\+', 'g')
    \ )<Cr>n

" copy
vnoremap <C-c> "yy <Bar> :call system('xclip -i -sel c', @y)<CR>

