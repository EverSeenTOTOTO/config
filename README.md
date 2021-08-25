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

3. Install oh-my-tmux

```bash
if [[ ! -d $HOME/.oh-my-tmux ]]
then
    git clone https://github.com/gpakosz/.tmux.git $HOME/.oh-my-tmux --depth 1
    ln -s -f $HOME/.oh-my-tmux/.tmux.conf $HOME/.tmux.conf
    cp $HOME/.oh-my-tmux/.tmux.conf.local $HOME
    echo '\
    set-option -g default-shell /bin/zsh \
# add truecolor support \
    set -g default-terminal "xterm-256color" \
    set-option -ga terminal-overrides ",*256col*:tc" \
# tpm plugins \
    set -g @plugin 'tmux-plugins/tmux-resurrect' \
# for vim \
    set -g @resurrect-strategy-vim 'session' \
    set -g @resurrect-capture-pane-contents 'on' # 开启恢复面板内容功能 \
    set -g @resurrect-save-shell-history 'on' \
# for neovim \
# set -g @resurrect-strategy-nvim 'session' \
    set -g @plugin 'tmux-plugins/tmux-continuum' \
    set -g @continuum-restore 'on' \
    set -g @continuum-save-interval '60' # 每小时备份一次 \
    set -g @continuum-boot 'on' \
    ' >> $HOME/.tmux.conf.local
fi
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

