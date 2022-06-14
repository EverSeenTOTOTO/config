# My dotfiles and configs

> After clone this repo, you can use [zx](https://github.com/google/zx/blob/main/docs/markdown.md) to setup.
>
> ```bash
> zx README.md
> ```

## Copy dot files

```bash
ls -A | /usr/bin/grep '^\.' | /usr/bin/grep -vE '^\.(git|ssh)$' | /usr/bin/grep -vE '\.md$' |  xargs -I % bash -c "cp -r % ~/"
```

## Install oh-my-zsh (require `zsh` to be installed)

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

## Install tmux plugins

```bash
TMUX_PLUG=~/.tmux/plugins

if [[ ! -e $TMUX_PLUG/vim-tmux-navigator ]]; then
  git clone https://github.com/christoomey/vim-tmux-navigator.git $TMUX_PLUG/vim-tmux-navigator --depth 1
fi
```

## Install `fzf`

```bash
if [[ ! -e ~/.fzf ]]; then
  git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
  ~/.fzf/install
fi
```

## Install pyenv

```bash
# pyenv
if [[ ! -e ~/.pyenv ]]; then
    read -p "Do U want to install pyenv?" -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        git clone https://github.com/pyenv/pyenv.git ~/.pyenv --depth 1
        cd ~/.pyenv 
        src/configure 
        make -C src
        cd -
    fi
fi
```

## Install nvm

```
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

## Install npm globals

```bash
NPM_GLOBALS=\`npm ls -g --depth 0\`
for dep in pm2 yarn gtop vls typescript bash-language-server vscode-langservers-extracted stylelint-lsp svelte-language-server vim-language-server
do
  if [[ -z $(echo $NPM_GLOBALS | grep $dep) ]]
  then
    echo "npm global install $dep"
    npm i -g $dep
  fi
done
```

## Install pip packages

```bash
PIP_PKGS=\`pip list\`
for pkg in cmake-language-server
do 
  if [[ -z $(echo $PIP_PKGS | grep $pkg) ]]
  then
    echo "pip install $pkg"
    pip install $pkg
  fi 
done
# pip3 install torch torchvision torchaudio --extra-index-url https://download.pytorch.org/whl/cu113
```

## Install `cargo` tools

Install rust and some mordern command line tools writen in rust.

```bash
if ! command -v cargo > /dev/null 2>&1; then
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | bash -s -- -y
  source $HOME/.cargo/env
  rustup component add rust-src clippy
  echo 'install mordern linux commands with cargo...'
  cargo install --locked ripgrep lsd bat fd-find du-dust gping 
fi

# rust-analyzer
if ! command -v rust-analyzer > /dev/null 2>&1; then
  curl -L https://github.com/rust-analyzer/rust-analyzer/releases/latest/download/rust-analyzer-x86_64-unknown-linux-gnu.gz | gunzip -c - ~/.cargo/bin/rust-analyzer
  chmod +x ~/.cargo/bin/rust-analyzer
fi
```


## Install `FiraCode` (use `nerd fonts` patched version)

```bash
if [[ ! -e ~/.nerd-fonts ]]; then
    git clone https://github.com/ryanoasis/nerd-fonts.git ~/.nerd-fonts --depth 1
    cd ~/.nerd-fonts 
    ./install.sh FiraCode
    cd -
fi
```
