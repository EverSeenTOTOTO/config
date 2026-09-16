---
name: land
description: Bootstrap a Linux machine from this config repo — copy dotfiles, link Claude Code skills, and install toolchain modules (Oh My Zsh/fzf/z, bun globals, Lua 5.1 + LSP, rustup + cargo tools, uv, FiraCode Nerd Font, WASM toolchains). Use when landing on a fresh machine, re-syncing dotfiles after pulling config changes, or when asked to set up any of these modules. Idempotent and safe to re-run.
---

# Land

Set up a machine from this repo. Every step checks current state first and skips what is already done, so re-running after pulling config changes is cheap and safe.

## Workflow

1. Locate the repo root (below).
2. Check prerequisites.
3. Copy dotfiles into `$HOME`.
4. Link Claude Code skills.
5. Ask which modules to install, then run them from [references/modules.md](references/modules.md).
6. Report a summary and remind the user to restart the shell (`exec zsh`).

## 1. Locate the repo

Prefer the cwd if it contains this skill (`.agents/skills/land/`); otherwise fall back to `~/repos/config`. If neither exists, clone first:

```bash
git clone git@github.com:EverSeenTOTOTO/config.git ~/repos/config
```

Run all later steps from the repo root.

## 2. Prerequisites

Verify each of: `git curl wget gcc make tar cmake node bun`.

If any is missing, stop, tell the user which ones and the usual install command (Debian/Ubuntu package names), and re-check after they install. Do not attempt installs of prerequisites yourself unless asked.

## 3. Copy dotfiles

Copy everything from the repo root into `$HOME` **except** the excludes below:

- `.git`, `.ssh`, `.claude` — never copy (`.claude` would clobber the live `~/.claude`)
- `*.json`, `*.md`, `*.mjs`, `*.bak` — machine-local or generated

```bash
for file in .[!.]* *; do
  case "$file" in
    .git|.ssh|.claude|*.json|*.md|*.mjs|*.bak) continue ;;
  esac
  [ -e "$file" ] && command cp -r "$file" ~/
done
find ~ -maxdepth 1 -name 'README.md*.mjs' -delete
```

Use `command cp` — a plain `cp` may be aliased to `cp -i` in the user's shell, which declines every overwrite when stdin is absent. Use `find … -delete` for the leftover cleanup — a bare `rm ~/README.md-*.mjs` aborts under zsh's `nomatch` when no file matches.

`keybindings.json`, `settings.json`, and `.luarc.json` are intentionally excluded — they are per-machine, copy them manually only if the user asks.

## 4. Link Claude Code skills

Symlink every skill in `~/.agents/skills/` into `~/.claude/skills/` (the repo's `.agents/` dir is copied by step 3). `land` itself may already be linked — it was bootstrapped from the repo before this run — and the existence guard handles that:

```bash
mkdir -p ~/.claude/skills
for skill in ~/.agents/skills/*; do
  [ -e "$skill" ] || continue
  name=$(basename "$skill")
  [ -e ~/.claude/skills/"$name" ] || ln -s "$skill" ~/.claude/skills/"$name"
done
```

## 5. Modules

Ask the user which modules to run (multi-select, default all). Then read [references/modules.md](references/modules.md) and execute each selected module, honoring its guards.

| Module  | Installs                                                                 |
| ------- | ------------------------------------------------------------------------ |
| shell   | Oh My Zsh + autosuggestions + syntax-highlighting + powerlevel10k, fzf, z |
| node    | bun globals (commitizen, pm2, typescript, biome, vue/ts LSPs…), vue-ts5  |
| lua     | Lua 5.1.5 from source, lua-language-server                              |
| rust    | rustup + components, cargo tools (ripgrep, lsd, bat, fd, …)              |
| python  | uv                                                                       |
| font    | FiraCode Nerd Font                                                       |
| wasm    | wasmtime, wabt, wasi-sdk                                                 |

## 6. Report

Summarize per module and per step: installed / skipped (already present) / failed. If a module fails, continue with the remaining modules instead of aborting. Finish with: restart the shell (`exec zsh`) to pick up the new config.

## Conventions

- **Check before acting** — run each guard before installing; report "skipped" when it passes.
- **PATH additions go to `~/.exports.local`**, never to `.exports` (which is repo-managed). `~/.profile` sources `*.local` variants automatically. Append only if the line is not already present.
- **Announce sudo steps** (e.g. `make install` for Lua) before running them.
- Leave the machine as-is on failure — no rollback, just an honest report.
