# My dotfiles and configs

> After cloning this repo, you can use [zx](https://github.com/google/zx/blob/main/docs/markdown.md) to set up.
>
> ```bash
> zx README.md
> ```

## Prerequisites

```javascript
// ===== Common Utilities =====
const HOME = os.homedir();
const resolveHome = (...parts) => path.resolve(HOME, ...parts);

const log = {
  start: (name) => echo(`\n----- Starting: ${chalk.cyan(name)} -----`),
  done: (name) => echo(`----- Completed: ${chalk.cyan(name)} -----\n`),
  ok: (msg) => echo(`${chalk.green('✓')} ${msg}`),
  skip: (msg) => echo(`${chalk.yellow('⊘')} ${msg}`),
};

const ensureDir = (dir) => {
  if (!fs.existsSync(dir)) fs.mkdirSync(dir, { recursive: true });
};

// 确认是否继续执行模块
const confirm = async (name) => {
  const answer = await question(`Run ${chalk.cyan(name)}? [Y/n] `);
  return answer.toLowerCase() !== 'n';
};

// ===== Check Prerequisites =====
log.start('Checking prerequisites');

const requiredTools = ['git', 'curl', 'wget', 'gcc', 'make', 'tar', 'cmake', 'node', 'bun'];

for (const tool of requiredTools) {
  try {
    await which(tool);
    log.ok(tool);
  } catch {
    echo(chalk.red(`Error: ${tool} is not installed.`));
    process.exit(1);
  }
}

log.done('Checking prerequisites');
```

## Copy dot files

```javascript
log.start('Copy dot files');

const excludePattern = /^\.git$|\.ssh|\.bak|\.json|\.md|\.mjs$/;

for (const file of fs.readdirSync('.')) {
  if (!excludePattern.test(file)) {
    await $`cp -r ${file} ~/`;
  }
}

await $`rm -f README.md.mjs README.md-*.mjs`;

log.done('Copy dot files');
```

## Shell: Oh My Zsh

```javascript
log.start('Oh My Zsh');

const ohMyZsh = resolveHome('.oh-my-zsh/oh-my-zsh.sh');
const zshCustom = process.env.ZSH_CUSTOM || resolveHome('.oh-my-zsh/custom');

if (!fs.existsSync(ohMyZsh)) {
  await $`sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"`;
}

const zshPlugins = ['zsh-autosuggestions', 'zsh-syntax-highlighting'];
for (const plugin of zshPlugins) {
  const pluginPath = path.join(zshCustom, 'plugins', plugin);
  if (!fs.existsSync(pluginPath)) {
    await $`git clone https://github.com/zsh-users/${plugin} ${pluginPath} --depth 1`;
  }
}

const p10k = path.join(zshCustom, 'themes/powerlevel10k');
if (!fs.existsSync(p10k)) {
  await $`git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${p10k}`;
}

log.done('Oh My Zsh');
```

## Shell: fzf

```javascript
log.start('fzf');

if (!fs.existsSync(resolveHome('.fzf'))) {
  await $`git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf`;
  await $`~/.fzf/install --all`;
}

log.done('fzf');
```

## Shell: z command

```javascript
log.start('z command');

if (!fs.existsSync(resolveHome('.config/z.sh'))) {
  await $`wget https://raw.githubusercontent.com/rupa/z/master/z.sh -P ~/.config`;
}

log.done('z command');
```

## Node: Global packages (via bun)

```javascript
if (await confirm('Bun globals')) {
  log.start('Bun globals');

  const { stdout } = await $`bun pm ls -g`;
  const installed = stdout
    .split('\n')
    .filter((l) => l.includes('├──') || l.includes('└──'))
    .map((l) => l.replace(/.*[├└]── /, '').trim().replace(/@[^@]*$/, ''));

  const packages = [
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
    'vscode-langservers-extracted',
  ];

  for (const pkg of packages) {
    if (installed.includes(pkg)) {
      log.skip(`${pkg} already installed`);
    } else {
      echo(`Installing ${chalk.yellow(pkg)}...`);
      await spinner(() => $`bun add -g ${pkg}`);
    }
  }

  await $`echo '{ "path": "cz-conventional-changelog" }' > ${resolveHome('.czrc')}`;

  log.done('Bun globals');
} else {
  log.skip('Bun globals');
}
```

## Agent: Skills

```javascript
if (await confirm('Agent skills')) {
  log.start('Agent skills');

  const skillsDir = resolveHome('.agents/skills');
  const isEmpty = !fs.existsSync(skillsDir) || fs.readdirSync(skillsDir).length === 0;

  if (isEmpty) {
    const skills = ['lobehub/lobehub', 'obra/superpowers', 'anthropics/skills'];
    for (const skill of skills) {
      echo(`Adding ${chalk.yellow(skill)}...`);
      await $`npx skills add ${skill}`;
    }
  } else {
    log.skip('.agents/skills already populated');
  }

  log.done('Agent skills');
} else {
  log.skip('Agent skills');
}
```

## Lua: 5.1 & LSP

```javascript
if (await confirm('Lua 5.1')) {
  log.start('Lua 5.1');

  const luaVersion = 'lua-5.1.5';

  try {
    await which('lua');
    log.skip(`lua (${luaVersion})`);
  } catch {
    await $`wget https://www.lua.org/ftp/${luaVersion}.tar.gz`;
    await $`tar -xvf ${luaVersion}.tar.gz`;
    cd(luaVersion);
    await $`make linux && sudo make install`;
    cd('..');
    await $`rm -rf ${luaVersion} ${luaVersion}.tar.gz`;
  }

  try {
    await which('lua-language-server');
    log.skip('lua-language-server');
  } catch {
    const luaLsHome = resolveHome('lua-ls');
    ensureDir(luaLsHome);
    cd(luaLsHome);

    const version = 'lua-language-server-3.6.23-linux-x64';
    await $`wget https://github.com/LuaLS/lua-language-server/releases/download/3.6.23/${version}.tar.gz`;
    await $`tar -xvf ${version}.tar.gz`;
    await $`rm -rf ${version} ${version}.tar.gz`;
    await $`echo 'export PATH="$HOME/lua-ls/bin:$PATH"' >> ~/.exports.local`;
  }

  log.done('Lua 5.1');
} else {
  log.skip('Lua 5.1');
}
```

## Rust: Cargo tools

```javascript
if (await confirm('Cargo tools')) {
  log.start('Cargo tools');

  try {
    await which('cargo');
  } catch {
    await $`curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh`;
    await $`source ~/.cargo/env`;
    await $`rustup component add rust-src clippy rust-analyzer`;
    await $`rustup target add wasm32-unknown-unknown`;
  }

  await $`cargo install ripgrep lsd bat fd-find du-dust stylua cargo-expand`;

  log.done('Cargo tools');
} else {
  log.skip('Cargo tools');
}
```

## Python: uv

```javascript
if (await confirm('uv')) {
  log.start('uv');

  try {
    await which('uv');
  } catch {
    await $`curl -LsSf https://astral.sh/uv/install.sh | sh`;
  }

  log.done('uv');
} else {
  log.skip('uv');
}
```

## Font: FiraCode Nerd Font

```javascript
if (await confirm('FiraCode Nerd Font')) {
  log.start('FiraCode Nerd Font');

  if (!fs.existsSync(resolveHome('.nerd-fonts'))) {
    await $`git clone https://github.com/ryanoasis/nerd-fonts.git ~/.nerd-fonts --depth 1`;
    cd(resolveHome('.nerd-fonts'));
    await $`./install.sh FiraCode`;
  } else {
    log.skip('already installed');
  }

  log.done('FiraCode Nerd Font');
} else {
  log.skip('FiraCode Nerd Font');
}
```

## WebAssembly: toolchains

```javascript
if (await confirm('WebAssembly toolchains')) {
  log.start('WebAssembly toolchains');

  if (!fs.existsSync(resolveHome('.wasmtime'))) {
    await $`curl https://wasmtime.dev/install.sh -sSf | bash`;
  }

  const wabtDir = resolveHome('repos/wabt');
  if (!fs.existsSync(wabtDir)) {
    ensureDir(wabtDir);
    cd(wabtDir);
    await $`git clone --recursive https://github.com/WebAssembly/wabt .`;
    await $`git submodule update --init`;
    await $`mkdir build && cd build && cmake .. && cmake --build .`;
    await $`mv ./* ~/.wasmtime/bin`;
  }

  const wasiDir = resolveHome('repos/wasi');
  if (!fs.existsSync(wasiDir)) {
    ensureDir(wasiDir);
    cd(wasiDir);
    await $`git clone --recursive https://github.com/WebAssembly/wasi-sdk.git .`;
    await $`bash ci/build.sh`;
    await $`cmake --build build/toolchain --target dist`;
    await $`cmake --build build/sysroot --target dist`;
    ensureDir(path.join(wasiDir, 'dist-my-platform'));
    await $`cp build/toolchain/dist/* build/sysroot/dist/* dist-my-platform`;
    await $`./ci/merge-artifacts.sh`;
  }

  log.done('WebAssembly toolchains');
} else {
  log.skip('WebAssembly toolchains');
}
```
