# my dotfiles and configs

> After clone this repo, you can use [zx](https://github.com/google/zx/blob/main/docs/markdown.md) to setup.
>
> ```bash
> zx README.md
> ```

1. Copy dot files

```bash
ls -A | /usr/bin/grep '^\.' | /usr/bin/grep -vE '^\.(git|ssh|rootvimrc)$' | /usr/bin/grep -vE '\.md$' |  xargs -I % bash -c "cp -r % ~/"
```

2. Install oh-my-zsh

> Require `zsh` to have been installed.

```bash
# install oh-my-zsh
if [[ ! -e ~/.oh-my-zsh/oh-my-zsh.sh ]]; then
  sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

install_omz_plugins() {
  ZSH_PLUG=$\{ZSH_CUSTOM:-~/.oh-my-zsh/custom\}/plugins
  for plug in $@
  do
    if [[ ! -e $ZSH_PLUG/$plug ]]
    then
      git clone https://github.com/zsh-users/$plug $ZSH_PLUG/$plug --depth 1
    fi
  done
}

# omz plugins
install_omz_plugins zsh-autosuggestions zsh-syntax-highlighting

# zsh theme p10k
if [[ ! -e $\{ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom\}/themes/powerlevel10k ]]; then
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git $\{ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom\}/themes/powerlevel10k
fi
```

3. Install tmux plugins

```bash
install_tmux_plugs() {
  TMUX_PLUG=~/.tmux/plugins
  for plug in $@
  do
    echo -e "install tpm plugin $plug"
    if [[ ! -e $TMUX_PLUG/$plug ]]; then
      git clone https://github.com/tmux-plugins/$plug $TMUX_PLUG/$plug --depth 1
    fi
  done
}
install_tmux_plugs tpm tmux-resurrect
if [[ ! -e $TMUX_PLUG/vim-tmux-navigator ]]; then
  git clone https://github.com/christoomey/vim-tmux-navigator.git $TMUX_PLUG/vim-tmux-navigator --depth 1
fi
```

4. Install `fzf`

```bash
if [[ ! -e ~/.fzf ]]; then
  git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
  ~/.fzf/install
fi
```

5. Install npm globals

```bash
npm_global=\`npm ls -g --depth 0\`
for dep in dockerfile-language-server-nodejs pm2 yarn bash-language-server neovim commitizen gtop
do
  if [[ -z $(echo $npm_global | grep $dep) ]]
  then
    echo "npm global install $dep"
    npm i -g $dep
  fi
done
```

6. `cargo` tools

Install rust and some mordern command line tools writen in rust.

```bash
if ! command -v cargo > /dev/null 2>&1; then
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | bash -s -- -y
  source $HOME/.cargo/env
  rustup component add clippy
  echo 'install mordern linux commands with cargo...'
  cargo install --locked ripgrep lsd bat fd-find du-dust gping 
fi
```

7. extra tools

```bash
# pyenv
if [[ ! -e ~/.pyenv ]]; then
    read -p "Do U want to install pyenv?" -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        git clone https://github.com/pyenv/pyenv.git ~/.pyenv
        cd ~/.pyenv 
        src/configure 
        make -C src
        cd -
    fi
fi

# nvm
if [[ ! -e ~/.nvm ]]; then
    read -p "Do U want to install nvm?" -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]
    then
      cd ~
      curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
      cd -
    fi
fi
```

8. `FiraCode` (use `nerd fonts` patched version)

```bash
if [[ ! -e ~/.nerd-fonts ]]; then
    git clone --depth 1 https://github.com/ryanoasis/nerd-fonts.git ~/.nerd-fonts
    cd ~/.nerd-fonts 
    ./install.sh FiraCode
    cd -
fi
```

Something I suggest for better experiance:

+ ripgrep for `grep`
+ lsd for `ls`
+ batcat for `cat`
+ fdfind for `find`
+ dust for `du`
+ gtop for `top`
+ gping for `ping`
+ git-filter-repo for git filter-branch

