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
    if (!/^(\.git|\.ssh|\.bak|\.json|README\.md(\.mjs)?)$/.test(file)) {
        await $`cp -r ${file} ~/`;
    }
}
```

## Install `omz` (require zsh to be installed)

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

## Install fzf

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

## Install nvm

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

## Install npm globals

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

## Install Lua 5.1

```js
const Lua = "lua-5.1.5";
const LuaRocks = "luarocks-3.9.1";

// install lua
which('lua')
  .then(() => echo(`already installed ${chalk.cyan(Lua)}`))
  .catch(async () => {
    echo(`${chalk.cyan(Lua)} is not found, downloading...`);

    await $`wget https://www.lua.org/ftp/${Lua}.tar.gz`;
    await $`tar -xvf ${Lua}.tar.gz`;

    cd(Lua);

    await $`make linux && sudo make install`;
})

// install luarocks
which("luarocks")
  .then(() => echo(`already installed ${chalk.cyan(LuaRocks)}`))
  .catch(async () => {
    echo(`${chalk.cyan(LuaRocks)} is not found, downloading...`);

    await $`wget https://luarocks.org/releases/${LuaRocks}.tar.gz`;
    await $`tar -xvf ${LuaRocks}.tar.gz`;

    cd(LuaRocks);

    await $`./configure && make && sudo make install`;
    await $`sudo luarocks install luaunit`; // a unit test framework
})
```

## Install `cargo` tools

Install rust and some mordern command line tools writen in rust.

```bash
if ! command -v cargo > /dev/null 2>&1; then
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | bash -s -- -y
  source ~/.cargo/env
  rustup component add rust-src clippy rust-analyzer
  rustup target add wasm32-unknown-unknown

  echo 'install mordern linux commands with cargo...'
  cargo install --locked ripgrep lsd bat fd-find du-dust stylua cargo-nextest cargo-expand

  # see https://rust-analyzer.github.io/manual.html#rustup
  ln -s $(rustup which rust-analyzer) ~/.cargo/bin/rust-analyzer
fi
```

## Install wabt and wasmtime

```bash
if [[ ! -e ~/.wasmtime ]]; then
  curl https://wasmtime.dev/install.sh -sSf | bash
  git clone --recursive https://github.com/WebAssembly/wabt 
  cd wabt
  git submodule update --init
  mkdir build
  cd build
  cmake ..
  cmake --build .
  mv ./* ~/.wasmtime/bin
fi
```

## Install FiraCode (use `nerd fonts` patched version)

```bash
if [[ ! -e ~/.nerd-fonts ]]; then
    git clone https://github.com/ryanoasis/nerd-fonts.git ~/.nerd-fonts --depth 1
    cd ~/.nerd-fonts 
    ./install.sh FiraCode
fi
```
