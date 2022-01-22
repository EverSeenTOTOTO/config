" Airline
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1

" coc-nvim
let g:coc_disable_uncaught_error = 1
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
nmap <leader>h :call CocAction('definitionHover')<CR>
nmap <leader>r <Plug>(coc-refactor)
nmap <leader>f  <Plug>(coc-fix-current)
nmap <leader>n <Plug>(coc-rename)
nmap <leader>. <Plug>(coc-command-repeat)
nmap <leader>a  <Plug>(coc-codeaction)
nmap <leader>[ <Plug>(coc-diagnostic-prev)
nmap <leader>] <Plug>(coc-diagnostic-next)
nmap <leader>gr <Plug>(coc-references)
nmap <leader>gm :call CocAction('organizeImport')<CR>
nmap <leader>l :CocList -N<space>
nmap <leader>y :CocList -A yank<CR>
nmap <leader>c :CocCommand<space>

nmap <silent> <C-p> <Plug>(coc-range-select-backward)
nmap <silent> <C-c> <Plug>(coc-cursors-position)
nmap <silent> <C-n> <Plug>(coc-cursors-word)*
xmap <silent> <C-n> y/\V<C-r>=escape(@",'/\')<CR><CR>gN<Plug>(coc-cursors-range)gn

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
      \'coc-go',
      \'coc-html',
      \'coc-json',
      \'coc-lua',
      \'coc-markdownlint',
      \'coc-pairs',
      \'coc-python',
      \'coc-stylelint',
      \'coc-tabnine',
      \'coc-tsserver',
      \'coc-vetur',
      \'coc-yaml'
      \]
" Highlight the symbol and its references when holding the cursor.
" autocmd CursorHold * silent call CocActionAsync('highlight')
autocmd User CocJumpPlaceholder call
				\ CocActionAsync('showSignatureHelp')
" scroll on float
nnoremap <nowait><expr> <C-d> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-d>"
nnoremap <nowait><expr> <C-u> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-u>"
inoremap <nowait><expr> <C-d> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
inoremap <nowait><expr> <C-u> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
	
" fzf
" Open files in vertical horizontal split
nnoremap <silent> <leader>v :call fzf#run({
\   'right': winwidth('.') / 2,
\   'sink':  'vertical botright split' })<CR>

nnoremap <silent> <leader>V :call fzf#run({
\   'dir': '~',
\   'right': winwidth('.') / 2,
\   'sink':  'vertical botright split' })<CR>

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

nnoremap <C-f> :FZF<cr>
nnoremap <C-s> :FZFLines<cr>
nnoremap <space><space> :History:<cr>
nnoremap <space>/ :History/<cr>
