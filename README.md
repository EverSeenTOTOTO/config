# My dotfiles and configs

> After clone this repo, you can use [zx](https://github.com/google/zx/blob/main/docs/markdown.md) to setup.
>
> ```bash
> zx README.md
> ```

## Copy dot files

```js
const files = fs.readdirSync('.');

for (const file of files) {
    if (!/^(\.git|\.ssh|README\.md(\.mjs)?)$/.test(file)) {
        await $`cp -r ${file} ~/`;
    }
}
```

## Install `omz` (require `zsh` to be installed)

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

## Install `tmux` plugins

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

## Install `z` command

```bash
if [[ ! -e ~/.config/z.sh ]]; then
    wget https://raw.githubusercontent.com/rupa/z/master/z.sh -P ~/.config
fi
```

## Install `nvm`

```js
within(async () => {
  $.prefix += 'export NVM_DIR=$HOME/.nvm; source $NVM_DIR/nvm.sh; ';
  $`nvm -v`.catch(async () => {
    const answer = await question("nvm not found, need to install?");

    if (/^y$/i.test(answer)) {
      await cd(process.env.HOME);
      await $`curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash`;
    }
  });
})
```

## Install `npm` globals

```js
const data = await $`npm ls -g --depth 0`
const installed = data.stdout.split("\n").map(pkg => pkg.trim());
const required = [
  "pm2",
  "yarn",
  "vls",
  "typescript",
  "typescript-language-server",
  "vscode-langservers-extracted",
  "stylelint-lsp",
  "commitizen",
  "@everseen/pen"
].map(pkg => new RegExp(pkg));

for (const pkg of required) {
  if (installed.some(name => pkg.test(name))) {
    await echo(`already installed ${chalk.green(pkg.source)}`);
  } else {
    await echo(`installing npm global pkg: ${chalk.yellow(pkg.source)}`);
    await $`npm i -g ${pkg.source}`;
  }
}
```

## Install `cargo` tools

Install rust and some mordern command line tools writen in rust.

```bash
if ! command -v cargo > /dev/null 2>&1; then
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | bash -s -- -y
  source ~/.cargo/env
  rustup component add rust-src clippy
  echo 'install mordern linux commands with cargo...'
  cargo install --locked ripgrep lsd bat fd-find du-dust
fi
```

## Install FiraCode (use `nerd fonts` patched version)

```bash
if [[ ! -e ~/.nerd-fonts ]]; then
    git clone https://github.com/ryanoasis/nerd-fonts.git ~/.nerd-fonts --depth 1
    cd ~/.nerd-fonts 
    ./install.sh FiraCode
    cd -
fi
```
