# My dotfiles and configs

> After cloning this repo, you can use [zx](https://github.com/google/zx/blob/main/docs/markdown.md) to set up.
>
> ```bash
> zx README.md
> ```

## Prerequisites

```javascript
echo(`----- Starting: ${chalk.cyan('Checking prerequisites')} -----`);

const requiredTools = ['git', 'curl', 'wget', 'gcc', 'make', 'tar', 'cmake', 'node', 'bun'];

for (const tool of requiredTools) {
  try {
    await which(tool);
  } catch {
    echo(`${chalk.red(`Error: ${tool} is not installed. Please install it before proceeding.`)}`);
    process.exit(1);
  }
}

echo(`----- Completed: ${chalk.cyan('Checking prerequisites')} -----`);
```

## Copy dot files

```javascript
echo(`----- Starting: ${chalk.cyan('Copy dot files')} -----`);

const files = fs.readdirSync('.');

for (const file of files) {
  if (!/^\.git$|\.ssh|\.bak|\.json|\.md|\.mjs$/.test(file)) {
    await $`cp -r ${file} ~/`;
  }
}

await $`rm -f README.md.mjs`;
await $`rm -f README.md-*.mjs`;

echo(`----- Completed: ${chalk.cyan('Copy dot files')} -----\n\n`);
```

## Install `omz` (Oh My Zsh)

```javascript
echo(`----- Starting: ${chalk.cyan('Install Oh My Zsh')} -----`);

if (!fs.existsSync(path.resolve(os.homedir(), '.oh-my-zsh/oh-my-zsh.sh'))) {
  await $`sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"`;
}

const installOmzPlugins = async (...plugins) => {
  const ZSH_PLUG = path.resolve(process.env.ZSH_CUSTOM || path.resolve(os.homedir(), '.oh-my-zsh/custom'), 'plugins');

  for (const plugin of plugins) {
    if (!fs.existsSync(`${ZSH_PLUG}/${plugin}`)) {
      await $`git clone https://github.com/zsh-users/${plugin} ${ZSH_PLUG}/${plugin} --depth 1`;
    }
  }
};

await installOmzPlugins('zsh-autosuggestions', 'zsh-syntax-highlighting');

const P10K = path.resolve(process.env.ZSH_CUSTOM || path.resolve(os.homedir(), '.oh-my-zsh/custom'), 'themes/powerlevel10k');

if (!fs.existsSync(P10K)) {
  await $`git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${P10K}`;
}

echo(`----- Completed: ${chalk.cyan('Install Oh My Zsh')} -----\n\n`);
```

## Install `fzf`

```javascript
echo(`----- Starting: ${chalk.cyan('Install fzf')} -----`);

if (!fs.existsSync(path.resolve(os.homedir(), '.fzf'))) {
  await $`git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf`;
  await $`~/.fzf/install --all`;
}

echo(`----- Completed: ${chalk.cyan('Install fzf')} -----\n\n`);
```

## Install `z` command

```javascript
echo(`----- Starting: ${chalk.cyan('Install z command')} -----`);

if (!fs.existsSync(path.resolve(os.homedir(), '.config/z.sh'))) {
  await $`wget https://raw.githubusercontent.com/rupa/z/master/z.sh -P ~/.config`;
}
echo(`----- Completed: ${chalk.cyan('Install z command')} -----\n\n`);
```

## Install npm globals (now using bun)

```javascript
echo(`----- Starting: ${chalk.cyan('Install bun globals')} -----`);

const data = await $`bun pm ls -g`;

function extractPackageNames(input) {
  return input
    .split('\n')
    .filter(line => line.includes('├──') || line.includes('└──'))
    .map(line => {
      // Remove the tree characters and trim
      const cleaned = line.replace(/.*[├└]── /, '').trim();

      // Find the last @ which indicates the version
      const lastAtIndex = cleaned.lastIndexOf('@');

      // Extract package name (everything before the last @)
      return cleaned.substring(0, lastAtIndex);
    });
}

const installed = extractPackageNames(data.stdout)

const required = [
  'commitizen',
  'cz-conventional-changelog',
  'git-split-diffs',
  'pm2',
  'stylelint-lsp',
  'typescript',
  '@biomejs/biome',
  '@vtsls/language-server',
  '@vue/language-server',
  '@vue/typescript-plugin',
  'vscode-langservers-extracted'
];

for (const pkg of required) {
  if (!installed.includes(pkg)) {
    echo(`Installing npm package: ${chalk.yellow(pkg)}`);
    await spinner(() => $`bun add -g ${pkg}`);
  } else {
    echo(`Already installed: ${chalk.green(pkg)}`);
  }
}

await $`echo '{ "path": "cz-conventional-changelog" }' > ${path.resolve(os.homedir(), '.czrc')}`;

echo(`----- Completed: ${chalk.cyan('Install bun globals')} -----\n\n`);

```

## Install Lua 5.1

```javascript
echo(`----- Starting: ${chalk.cyan('Install Lua 5.1')} -----`);

const luaVersion = 'lua-5.1.5';

try {
  await which('lua');
  echo(`${chalk.blue(luaVersion)} is already installed.`);
} catch {
  echo(`${chalk.cyan(luaVersion)} not found. Downloading...`);
  await $`wget https://www.lua.org/ftp/${luaVersion}.tar.gz`;
  await $`tar -xvf ${luaVersion}.tar.gz`;
  cd(luaVersion);
  await $`make linux && sudo make install`;
  cd('..');
  await $`rm -rf ${luaVersion} ${luaVersion}.tar.gz`;
}

try {
  await which('lua-language-server');
  echo(`${chalk.blue('lua-language-server')} is already installed.`);
} catch {
  echo(`Installing ${chalk.blue('lua-language-server')}...`);

  const luaLsHome = path.join(process.env.HOME, 'lua-ls');

  if (!fs.existsSync(luaLsHome)) {
    fs.mkdirSync(luaLsHome);
  }

  cd(luaLsHome);
  const luaLsVersion = 'lua-language-server-3.6.23-linux-x64';

  await $`wget https://github.com/LuaLS/lua-language-server/releases/download/3.6.23/${luaLsVersion}.tar.gz`;
  await $`tar -xvf ${luaLsVersion}.tar.gz`;
  await $`rm -rf ${luaLsVersion} ${luaLsVersion}.tar.gz`;
  await $`echo "export PATH=\"$HOME/lua-ls/bin:$PATH\"" >> ~/.exports.local`;
}

echo(`----- Completed: ${chalk.cyan('Install Lua 5.1')} -----\n\n`);
```

## Install `cargo` tools

```javascript
try {
  await which('cargo');
} catch {
  await $`curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh`;
  await $`source ~/.cargo/env`;
  await $`rustup component add rust-src clippy rust-analyzer`;
  await $`rustup target add wasm32-unknown-unknown`;
}

echo('----- Installing modern Linux commands with cargo... -----\n\n');
await $`cargo install ripgrep lsd bat fd-find du-dust stylua cargo-expand`;
```

## Install `uv`

```javascript
echo(`----- Starting: ${chalk.cyan('Install uv')} -----`);

try {
  await which('uv');
} catch {
  await $`curl -LsSf https://astral.sh/uv/install.sh | sh`;
}

echo(`----- Completed: ${chalk.cyan('Install uv')} -----\n\n`);
```

## Install FiraCode (Nerd Fonts patched version)

```javascript
echo(`----- Starting: ${chalk.cyan('Install FiraCode')} -----`);

if (!fs.existsSync(path.resolve(os.homedir(), '.nerd-fonts'))) {
  await $`git clone https://github.com/ryanoasis/nerd-fonts.git ~/.nerd-fonts --depth 1`;
  cd(path.resolve(os.homedir(), '.nerd-fonts'));
  await $`./install.sh FiraCode`;
}
```

## Install wasm toolchains

```javascript
echo(`----- Starting: ${chalk.cyan('Install wabt and wasmtime')} -----`);

if (!fs.existsSync(path.resolve(os.homedir(), '.wasmtime'))) {
  await $`curl https://wasmtime.dev/install.sh -sSf | bash`;
}

const wabtRepo = path.resolve(os.homedir(), 'repos/wabt');

if (!fs.existsSync(wabtRepo)) {
  fs.mkdirSync(wabtRepo, { recursive: true });

  cd(wabtRepo);
  await $`git clone --recursive https://github.com/WebAssembly/wabt .`;
  await $`git submodule update --init`;
  await $`mkdir build && cd build && cmake .. && cmake --build .`;
  await $`mv ./* ~/.wasmtime/bin`;
}

const wasiRepo = path.resolve(os.homedir(), 'repos/wasi');

if (!fs.existsSync(wasiRepo)) {
  fs.mkdirSync(wasiRepo, { recursive: true });

  cd(wasiRepo);
  await $`git clone --recursive https://github.com/WebAssembly/wasi-sdk.git .`
  await $`bash ci/build.sh`;
  await $`cmake --build build/toolchain --target dist`;
  await $`cmake --build build/sysroot --target dist`;

  fs.mkdirSync(path.resolve(wasiRepo, 'dist-my-platform'));
  await $`cp build/toolchain/dist/* build/sysroot/dist/* dist-my-platform`;
  await $`./ci/merge-artifacts.sh`;
}
```
