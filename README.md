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
    if (!/(\.git|\.ssh|\.bak|\.json|README\.md(\.mjs)?)$/.test(file)) {
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

## Install `nvm`

```js
echo(`installling or updating ${chalk.yellow('nvm')}`);
// await $`wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash`;
```

## Install npm globals

```js
const data = await $`npm ls -g --depth 0`
const installed = data.stdout.split("\n").map(pkg => pkg.trim());
const required = [
  "commitizen",
  "cz-conventional-changelog",
  "pm2",
  "stylelint-lsp",
  "svelte-language-server",
  "typescript",
  "typescript-language-server",
  "@vue/language-server",
  "@vue/typescript-plugin",
  "vscode-langservers-extracted",
  "yarn",
];
const regex = required.map(pkg => new RegExp(pkg));

for (let i = 0; i < required.length; ++i) {
  const pkg = regex[i];

  if (installed.some(name => pkg.test(name))) {
    echo(`already installed ${chalk.green(pkg.source)}`);
  } else {
    echo(`installing npm global pkg: ${chalk.yellow(required[i])}`);
    await spinner(() => $`npm i -g ${required[i]}`)
  }
}

await $`echo '{ "path": "cz-conventional-changelog" }' > ~/.czrc`;
```

## Install Lua 5.1

```js
const Lua = "lua-5.1.5";

// install lua
try {
  await which('lua');
  echo(`already installed ${chalk.blue(Lua)}`);
} catch {
  echo(`${chalk.cyan(Lua)} is not found, downloading...`);

  await $`wget https://www.lua.org/ftp/${Lua}.tar.gz`;
  await $`tar -xvf ${Lua}.tar.gz`;

  cd(Lua);

  await $`make linux && sudo make install`;
}

// lua-ls
try {
  await which('lua-language-server');
  echo(`already installed ${chalk.blue("lua-ls")}`);
} catch {
  echo(`installing ${chalk.blue("lua-ls")}...`);
  if (os.platform() === 'darwin') {
    await $`brew install lua-language-server`;
  } else if (os.platform() === 'linux') {
    const LUA_LS = "lua-language-server-3.6.23-linux-x64.tar.gz";
    const LUA_LS_HOME = path.join(process.env.HOME, 'lua-ls');
  
    echo(`install lua-language-server in ${chalk.yellow(LUA_LS_HOME)}...`)

    if (!fs.existsSync(LUA_LS_HOME)) {
      await $`mkdir ${LUA_LS_HOME}`;
    }
  
    cd(LUA_LS_HOME);
    await $`wget https://github.com/LuaLS/lua-language-server/releases/download/3.6.23/${LUA_LS}`;
    await $`tar -xvf ${LUA_LS}`;
    await $`echo "export PATH=\"$HOME/lua-ls/bin:$PYENV_ROOT/bin:$RISCV/bin:$WASMTIME_HOME/bin:$PATH\"" >> ~/.exports.local`;
  }
}
```

## Install `cargo` tools

Install rust and some mordern command line tools writen in rust.

```bash
if ! command -v cargo > /dev/null 2>&1; then
  curl --proto '=https' --tlsv1.2 -sSf https://rsproxy.cn/rustup-init.sh | bash -s -- -y
  source ~/.cargo/env
  rustup component add rust-src clippy rust-analyzer
  rustup target add wasm32-unknown-unknown
  # see https://rust-analyzer.github.io/manual.html#rustup
  # ln -s $(rustup which rust-analyzer) ~/.cargo/bin/rust-analyzer
fi

echo 'install mordern linux commands with cargo...'
cargo install ripgrep lsd bat fd-find du-dust stylua cargo-expand
```

## Install FiraCode (use `nerd fonts` patched version)

```bash
if [[ ! -e ~/.nerd-fonts ]]; then
    git clone https://github.com/ryanoasis/nerd-fonts.git ~/.nerd-fonts --depth 1
    cd ~/.nerd-fonts 
    ./install.sh FiraCode
fi
```

## Install wabt and wasmtime

```bash
if [[ ! -e ~/.wasmtime ]]; then
  curl https://wasmtime.dev/install.sh -sSf | bash
  mkdir -p ~/repos/wabt
  git clone --recursive https://github.com/WebAssembly/wabt ~/repos/wabt
  cd ~/repos/wabt
  git submodule update --init
  mkdir build
  cd build
  cmake ..
  cmake --build .
  mv ./* ~/.wasmtime/bin
fi
```
