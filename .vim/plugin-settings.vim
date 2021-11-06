" easymotion config
let g:EasyMotion_smartcase = 1
" keep cursor colum when JK motion
"let g:EasyMotion_startofline = 0 
map <leader>s <Plug>(easymotion-j)
map <leader>w <Plug>(easymotion-k)
nmap <leader>z <Plug>(easymotion-overwin-f2)

" Airline
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1

" UltiSnips
let g:UltiSnipsSnippetDirectories=[$HOME.'/.vim/UltiSnips']
let g:UltiSnipsExpandTrigger="<c-j>"
let g:UltiSnipsJumpForwardTrigger="<c-j>"
let g:UltiSnipsJumpBackwardTrigger="<c-k>"

" If you want :UltiSnipsEdit to split your window.
let g:UltiSnipsEditSplit="vertical"

" coc-nvim
hi CocCursorRange guibg=#b16286 guifg=#ebdbb2

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

nmap <leader>d <Plug>(coc-definition)
nmap <leader>t <Plug>(coc-type-definition)
nmap <leader>i <Plug>(coc-implementation)
nmap <leader>r <Plug>(coc-references)
nmap <leader>f  <Plug>(coc-fix-current)
nmap <leader>n <Plug>(coc-rename)
nmap <leader>. <Plug>(coc-command-repeat)
nmap <leader>a  <Plug>(coc-codeaction-selected)
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>gr <Plug>(coc-refactor)
nmap <leader>ga  <Plug>(coc-codeaction)
nmap <leader>gf  <Plug>(coc-format-selected)
xmap <leader>gf  <Plug>(coc-format-selected)
nmap <leader>[ <Plug>(coc-diagnostic-prev)
nmap <leader>] <Plug>(coc-diagnostic-next)
nmap <leader>gm :CocCommand tsserver.organizeImports<CR>
nmap <leader>l :CocList<space>
nmap <leader>y :CocList -A --normal yank<CR>
nmap <leader>c :CocCommand<space>

nmap <silent> <C-c> <Plug>(coc-cursors-position)
nmap <silent> <C-n> <Plug>(coc-cursors-word)*
xmap <silent> <C-n> y/\V<C-r>=escape(@",'/\')<CR><CR>gN<Plug>(coc-cursors-range)gn

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType javascript,typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder.
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

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
      \'coc-emoji',
      \'coc-eslint',
      \'coc-git',
      \'coc-html',
      \'coc-json',
      \'coc-lists',
      \'coc-markdownlint',
      \'coc-pairs',
      \'coc-python',
      \'coc-stylelint',
      \'coc-tabnine',
      \'coc-tsserver',
      \'coc-vetur',
      \'coc-yaml',
      \'coc-yank'
      \]
" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

" open Coc Explorer
nnoremap <C-t> :CocCommand explorer
    \ --toggle
    \ --sources=file+
    \ <CR>

" fzf
" Open files in vertical horizontal split
nnoremap <silent> <leader>v :call fzf#run({
\   'right': winwidth('.') / 2,
\   'sink':  'vertical botright split' })<CR>
nnoremap <silent> <leader>C :call fzf#run({
\   'source':
\     map(split(globpath(&rtp, "colors/*.vim"), "\n"),
\         "substitute(fnamemodify(v:val, ':t'), '\\..\\{-}$', '', '')"),
\   'sink':    'colo',
\   'options': '+m',
\   'left':    30
\ })<CR>

function! s:buflist()
  redir => ls
  silent ls
  redir END
  return split(ls, '\n')
endfunction

function! s:bufopen(e)
  execute 'buffer' matchstr(a:e, '^[ 0-9]*')
endfunction

nnoremap <silent> <leader><cr> :call fzf#run({
\   'source':  reverse(<sid>buflist()),
\   'sink':    function('<sid>bufopen'),
\   'options': '+m',
\   'down':    len(<sid>buflist()) + 2
\ })<CR>

command! FZFMru call fzf#run({
\ 'source':  reverse(s:all_files()),
\ 'sink':    'edit',
\ 'options': '-m -x +s',
\ 'down':    '40%' })

function! s:all_files()
  return extend(
  \ filter(copy(v:oldfiles),
  \        "v:val !~ 'fugitive:\\|NERD_tree\\|^/tmp/\\|.git/'"),
  \ map(filter(range(1, bufnr('$')), 'buflisted(v:val)'), 'bufname(v:val)'))
endfunction

function! s:line_handler(l)
  let keys = split(a:l, ':\t')
  exec 'buf' keys[0]
  exec keys[1]
  normal! ^zz
endfunction

function! s:buffer_lines()
  let res = []
  for b in filter(range(1, bufnr('$')), 'buflisted(v:val)')
    call extend(res, map(getbufline(b,0,"$"), 'b . ":\t" . (v:key + 1) . ":\t" . v:val '))
  endfor
  return res
endfunction

command! FZFLines call fzf#run({
\   'source':  <sid>buffer_lines(),
\   'sink':    function('<sid>line_handler'),
\   'options': '--extended --nth=3..',
\   'down':    '60%'
\})

function! s:fzf_neighbouring_files()
  let current_file =expand("%")
  let cwd = fnamemodify(current_file, ':p:h')
  let command = 'ag -g "" -f ' . cwd . ' --depth 0'

  call fzf#run({
        \ 'source': command,
        \ 'sink':   'e',
        \ 'options': '-m -x +s',
        \ 'window':  'enew' })
endfunction

command! FZFNeigh call s:fzf_neighbouring_files()

