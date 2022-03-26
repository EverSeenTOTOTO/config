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
nmap <leader>r <Plug>(coc-refactor)
nmap <leader>n <Plug>(coc-rename)
nmap <leader>. <Plug>(coc-command-repeat)
nmap <leader>a  <Plug>(coc-codeaction)
nmap <leader>[ <Plug>(coc-diagnostic-prev)
nmap <leader>] <Plug>(coc-diagnostic-next)
nmap <leader>h :call CocActionAsync('definitionHover')<CR>
nmap <leader>gr <Plug>(coc-references)
nmap <leader>gm :call CocActionAsync('organizeImport')<CR>
nmap <leader>o :CocList -N outline<CR>
nmap <leader>l :CocList -N<space>
nmap <leader>c :CocCommand<space>

nmap <silent> <C-p> <Plug>(coc-range-select-backward)
nmap <silent> <C-c> <Plug>(coc-cursors-position)
nmap <silent> <C-n> <Plug>(coc-cursors-word)*
xmap <silent> <C-n> y/\V<C-r>=escape(@",'/\')<CR><CR>gN<Plug>(coc-cursors-range)gn

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
      \'coc-rls',
      \'coc-stylelint',
      \'coc-svelte',
      \'coc-tsserver',
      \'coc-vetur',
      \'coc-word',
      \'coc-yaml',
      \'@everseen/coc-poem',
      \]

au User CocJumpPlaceholder call
				\ CocActionAsync('showSignatureHelp')
au VimEnter * call coc#rpc#notify('runCommand', ['poem.boot'])

" Map function and class text objects
" NOTE: Requires 'textDocument.documentSymbol' support from the language server.
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

if has('nvim-0.4.0') || has('patch-8.2.0750')
  nnoremap <silent><nowait><expr> <C-d> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-d>"
  nnoremap <silent><nowait><expr> <C-u> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-u>"
  inoremap <silent><nowait><expr> <C-d> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
  inoremap <silent><nowait><expr> <C-u> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
  vnoremap <silent><nowait><expr> <C-d> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-d>"
  vnoremap <silent><nowait><expr> <C-u> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-u>"
endif

" fzf
" Open files in vertical horizontal split
nnoremap <silent> <leader>v :call fzf#run({
\   'right': winwidth('.') / 2,
\   'sink':  'vertical botright split' })<CR>

command! -nargs=* -bang Rg call RipgrepFzf(<q-args>, <bang>0)

nnoremap <C-f> :Files<cr>
nnoremap <C-s> :BLines<cr>
nnoremap <C-m> :Marks<cr>
nnoremap <space><space> :History:<cr>
nnoremap <space>/ :History/<cr>

