# my dotfiles and configs

> After clone this repo, you can use [zx](https://github.com/google/zx/blob/main/docs/markdown.md) to setup.
> ```bash
> zx README.md
> ```

1. Copy dot files

```bash
ls -A | grep '^\.' | grep -Ev '^\.(git|ssh)$'|  xargs -I % bash -c "cp -r % ~/"
```


2. Install oh-my-zsh

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
install_tmux_plugs tpm tmux-resurrect tmux-battery tmux-cpu tmux-urlview tmux-open
```

4. Install npm globals

```bash
npm_global=\`npm ls -g --depth 0\`
for dep in dockerfile-language-server-nodejs pm2 yarn git-split-diffs
do
  if [[ -z $(echo $npm_global | grep $dep) ]]
  then
    echo "npm global install $dep"
    npm i -g $dep
  fi
done
```

5. Extra steps

You can install these for better experiance:

+ nerd-fonts (fira-code)
+ autojump
+ translate-shell

