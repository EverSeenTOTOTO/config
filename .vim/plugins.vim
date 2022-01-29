" vim-plug 插件
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  au VimEnter * PlugInstall --sync | source $MYVIMRC
endif
call plug#begin('~/.vim/plugged')

" 主题和颜色
Plug 'cocopon/iceberg.vim'

" treesitter
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'nvim-treesitter/nvim-treesitter-textobjects'
Plug 'nvim-treesitter/playground'

" status bar
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" show Register
Plug 'junegunn/vim-peekaboo'

" fzf
Plug 'junegunn/fzf.vim'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
"
" VimSurround
Plug 'tpope/vim-surround'

" EditorCOnfig
Plug 'editorconfig/editorconfig-vim'

" tmux
Plug 'christoomey/vim-tmux-navigator'

" explorer icons
Plug 'ryanoasis/vim-devicons'

" coc.nvim
Plug 'neoclide/coc.nvim', {'branch': 'release'}

call plug#end()
