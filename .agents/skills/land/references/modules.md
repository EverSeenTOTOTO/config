# Module recipes

Install recipes for the `/land` modules. Each module lists **guards** (state checks) and **steps**. If every guard passes, skip the module and report "already installed". Execute steps in order; steps with their own guard run only when that guard fails.

- [Shell](#shell) — Oh My Zsh, plugins, powerlevel10k, fzf, z
- [Node](#node) — bun globals + vue-ts5 shim
- [Lua](#lua) — Lua 5.1.5 + lua-language-server
- [Rust](#rust) — rustup + cargo tools
- [Python](#python) — uv
- [Font](#font) — FiraCode Nerd Font
- [WASM](#wasm) — wasmtime, wabt, wasi-sdk

## Shell

### Oh My Zsh

Guard: `[ -f ~/.oh-my-zsh/oh-my-zsh.sh ]`

```bash
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

Then, with `ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"`:

```bash
for plugin in zsh-autosuggestions zsh-syntax-highlighting; do
  dir="$ZSH_CUSTOM/plugins/$plugin"
  [ -d "$dir" ] || git clone --depth 1 "https://github.com/zsh-users/$plugin" "$dir"
done

p10k="$ZSH_CUSTOM/themes/powerlevel10k"
[ -d "$p10k" ] || git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$p10k"
```

`.zshrc` already references the plugins and the theme — nothing to edit after install.

### fzf

Guard: `[ -d ~/.fzf ]`

```bash
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install --all
```

### z

Guard: `[ -f ~/.config/z.sh ]`

```bash
mkdir -p ~/.config
wget https://raw.githubusercontent.com/rupa/z/master/z.sh -P ~/.config
```

## Node

Bun global packages. Guard per package against `bun pm ls -g` output.

```bash
packages=(
  commitizen cz-conventional-changelog git-split-diffs pm2 stylelint-lsp typescript
  @biomejs/biome @vtsls/language-server @vue/language-server @vue/typescript-plugin
  vscode-langservers-extracted
)
installed=$(bun pm ls -g)
for pkg in "${packages[@]}"; do
  echo "$installed" | grep -q "$pkg" || bun add -g "$pkg"
done
echo '{ "path": "cz-conventional-changelog" }' > ~/.czrc
```

### vue-ts5 — TypeScript 5.x for vue_ls

TypeScript 7.x removed `tsserverlibrary.js`, which `@vue/language-server` depends on, and bun resolves `typescript` to 7.x. Keep a separate TS 5.x tree for vue_ls, installed via npm.

`dir="${BUN_INSTALL:-$HOME/.bun}/install/global/vue-ts5"`; guard: `[ -f "$dir/node_modules/typescript/lib/tsserverlibrary.js" ]`

```bash
mkdir -p "$dir" && cd "$dir"
npm init -y
npm install typescript@5
```

## Lua

### Lua 5.1.5

Guard: `command -v lua`

```bash
wget https://www.lua.org/ftp/lua-5.1.5.tar.gz
tar -xvf lua-5.1.5.tar.gz
( cd lua-5.1.5 && make linux && sudo make install )   # announce the sudo step
rm -rf lua-5.1.5 lua-5.1.5.tar.gz
```

### lua-language-server

Guard: `command -v lua-language-server`

```bash
v=lua-language-server-3.6.23-linux-x64
mkdir -p ~/lua-ls && cd ~/lua-ls
wget "https://github.com/LuaLS/lua-language-server/releases/download/3.6.23/$v.tar.gz"
tar -xvf "$v.tar.gz"
rm -rf "$v" "$v.tar.gz"
```

Then append to `~/.exports.local` (only if absent — see SKILL.md conventions):

```bash
export PATH="$HOME/lua-ls/bin:$PATH"
```

## Rust

Guard: `command -v cargo`

```bash
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
source ~/.cargo/env
```

Always run (idempotent on its own):

```bash
rustup component add rust-src clippy rust-analyzer
rustup target add wasm32-unknown-unknown
cargo install ripgrep lsd bat fd-find du-dust stylua cargo-expand
```

## Python

Guard: `command -v uv`

```bash
curl -LsSf https://astral.sh/uv/install.sh | sh
```

## Font

Guard: `[ -d ~/.nerd-fonts ]`

```bash
git clone --depth 1 https://github.com/ryanoasis/nerd-fonts.git ~/.nerd-fonts
( cd ~/.nerd-fonts && ./install.sh FiraCode )
```

## WASM

### wasmtime

Guard: `[ -d ~/.wasmtime ]`

```bash
curl https://wasmtime.dev/install.sh -sSf | bash
```

### wabt

Guard: `[ -d ~/repos/wabt ]`

```bash
mkdir -p ~/repos/wabt && cd ~/repos/wabt
git clone --recursive https://github.com/WebAssembly/wabt .
git submodule update --init
mkdir build && cd build
cmake .. && cmake --build .
mv wa* ~/.wasmtime/bin    # move the built tools (wat2wasm, wasm2wat, …) only
```

Note: move only the `wa*` binaries, not the whole `build/` dir (CMake cache and objects live there too).

### wasi-sdk

Guard: `[ -d ~/repos/wasi ]`

```bash
mkdir -p ~/repos/wasi && cd ~/repos/wasi
git clone --recursive https://github.com/WebAssembly/wasi-sdk.git .
bash ci/build.sh
cmake --build build/toolchain --target dist
cmake --build build/sysroot --target dist
mkdir -p dist-my-platform
cp build/toolchain/dist/* build/sysroot/dist/* dist-my-platform
./ci/merge-artifacts.sh
```
