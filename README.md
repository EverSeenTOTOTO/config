# my dotfiles and configs

> After clone this repo, you can use [zx](https://github.com/google/zx/blob/main/docs/markdown.md) to setup.
> ```bash
> zx README.md
> ```

1. Copy dot files

```bash
ls -A | grep '^\.' | grep -Ev '^\.(git|ssh)$'|  xargs -I % bash -c "cp -r % ~/"
# for nvim
cp ~/.vim/coc-settings.json ~/.config/nvim/
```


2. Install oh-my-zsh

> Require `zsh` to have been installed.

```bash
if ! command -v zsh > /dev/null 2>&1; then
 sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

install_zsh_plugins() {
  ZSH_PLUG=$\{ZSH_CUSTOM:-~/.oh-my-zsh/custom\}/plugin
  for plug in $@
  do
    if [[ ! -d $ZSH_PLUG/$plug ]]
    then
      git clone https://github.com/zsh-users/$plug $ZSH_PLUG/$plug --depth 1
    fi
  done
}

install_zsh_plugins zsh-autosuggestions zsh-syntax-highlighting
```

3. Install tmux

```bash
install_tmux_plugs() {
  TMUX_PLUG=~/.tmux/plugins
  for plug in $@
  do
    echo -e "install tpm plugin $plug"
    if [[ ! -d $TMUX_PLUG/$plug ]]; then
      git clone https://github.com/tmux-plugins/$plug $TMUX_PLUG/$plug --depth 1
    fi
  done
}
install_tmux_plugs tpm tmux-resurrect tmux-battery tmux-cpu
if [[ ! -d $TMUX_PLUG/vim-tmux-navigator ]]; then
  git clone https://github.com/christoomey/vim-tmux-navigator.git $TMUX_PLUG/vim-tmux-navigator --depth 1
fi
```

4. Install `fzf`

```bash
if [[ ! -d ~/.fzf ]]; then
  git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
  ~/.fzf/install
fi
```

5. Install npm globals

```bash
npm_global=\`npm ls -g --depth 0\`
for dep in dockerfile-language-server-nodejs pm2 yarn git-split-diffs np bash-language-server neovim standard-version gtop
do
  if [[ -z $(echo $npm_global | grep $dep) ]]
  then
    echo "npm global install $dep"
    npm i -g $dep
  fi
done
```

6. `cargo` tools

> See the last part of this document.

```bash
if ! command -v cargo > /dev/null 2>&1; then
  echo 'install mordern linux commands with cargo...'
  cargo install --locked ripgrep lsd bat fd-find du-dust gping 
fi
```

7. Extra steps

```bash
# autojump
read -p "Do U want to install autojump?" -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]
then
  echo "installing autojump"
  git clone git://github.com/wting/autojump.git autojump --depth 1
  cd autojump
  ./install.py
  cd -
fi

#nvm
read -p "Do U want to install nvm?" -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]
then
  cd ~
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
  cd -
fi
```

Something I suggest for better experiance:

+ nerd-fonts (fira-code)
+ translate-shell
+ ripgrep for `grep`
+ lsd for `ls`
+ batcat for `cat`
+ fdfind for `find`
+ dust for `du`
+ gtop for `top`
+ gping for `ping`
+ git-filter-repo for git filter-branch

