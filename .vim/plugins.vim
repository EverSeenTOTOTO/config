" vim-plug 插件
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif
call plug#begin('~/.vim/plugged')

" 主题和颜色
Plug 'rakr/vim-one'
Plug 'frenzyexists/aquarium-vim', { 'branch': 'develop' }
Plug 'cocopon/iceberg.vim'
Plug 'rafi/awesome-vim-colorschemes'
Plug 'gosukiwi/vim-atom-dark'
Plug 'rhysd/vim-color-spring-night'


" status bar
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" EasyMotion
Plug 'easymotion/vim-easymotion'

" fzf
Plug 'junegunn/fzf.vim'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }

" comment
Plug 'tpope/vim-commentary'

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
