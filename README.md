# My dotfiles and configs

Dotfiles and toolchain setup for my Linux machines. Setup is driven by the [`land`](.agents/skills/land/SKILL.md) skill — an agent-friendly, idempotent replacement for the old `zx README.md` literate script.

## Quick start (new machine)

1. Install [Claude Code](https://claude.com/claude-code) and `git`.
2. Clone the repo and bootstrap the `land` skill (skills live in the tool-agnostic `.agents/skills/`; hook them up to whatever agent you use — for Claude Code, a symlink):

   ```bash
   git clone git@github.com:EverSeenTOTOTO/config.git ~/repos/config
   mkdir -p ~/.claude/skills
   ln -s ~/repos/config/.agents/skills/land ~/.claude/skills/land
   cd ~/repos/config
   claude
   ```

3. Run `/land`. It checks prerequisites (git, curl, wget, gcc, make, tar, cmake, node, bun), copies the dotfiles, links skills, and lets you pick which modules to install. Everything is idempotent — re-run any time, e.g. after pulling config changes.

## Modules

| Module  | Installs                                                                  |
| ------- | ------------------------------------------------------------------------- |
| shell   | Oh My Zsh + zsh-autosuggestions + zsh-syntax-highlighting + powerlevel10k, fzf, z |
| node    | bun globals (commitizen, pm2, typescript, biome, vue/ts LSPs, …) + a TS 5.x shim for `vue_ls` |
| lua     | Lua 5.1.5 (built from source), lua-language-server → `~/lua-ls`           |
| rust    | rustup (+ clippy, rust-analyzer, wasm32 target), cargo tools (ripgrep, lsd, bat, fd, du-dust, stylua, cargo-expand) |
| python  | uv                                                                        |
| font    | FiraCode Nerd Font                                                        |
| wasm    | wasmtime, wabt, wasi-sdk                                                  |

## Layout

- `.zshrc` / `.profile` / `.exports` / `.aliases` — shell; `~/.profile` also sources `~/.exports.local` etc. for machine-specific overrides
- `.vimrc`, `.tmux.conf`, `.config/` — editor and terminal apps
- `boot.js` — pm2 boot script (zx)
- `.agents/skills/` — agent skills, tool-agnostic by design; `/land` copies them to `~/.agents/skills` and symlinks into `~/.claude/skills` for Claude Code (includes `land` itself)

`keybindings.json`, `settings.json`, and `.luarc.json` are per-machine and are intentionally not copied by `/land`.
