---
name: land
description: Bootstrap a Linux machine from this config repo — copy dotfiles, link agent skills, and install toolchain domains via sub-skills (git, zsh, node, lua, rust, python, font, wasm). Run as `/land` for the full setup, or `/land <domain>` for a single domain. Idempotent and safe to re-run.
---

# Land

Set up a machine from this repo. Every sub-skill checks current state first and skips what is already done, so re-running after pulling config changes is cheap and safe.

## Routing

- **`/land <domain>`** — run a single sub-skill: open `<domain>/SKILL.md` next to this file and execute it, honoring its guards.
  [git](git/SKILL.md) · [zsh](zsh/SKILL.md) · [node](node/SKILL.md) · [lua](lua/SKILL.md) · [rust](rust/SKILL.md) · [python](python/SKILL.md) · [font](font/SKILL.md) · [wasm](wasm/SKILL.md)
- **`/land`** — full bootstrap, via the workflow below.

## Workflow

1. Locate the repo root (below).
2. Check prerequisites.
3. Copy dotfiles into `$HOME`.
4. Link agent skills.
5. Ask which domains to install (multi-select, default all), then run each selected sub-skill from its `<domain>/SKILL.md`.
6. Report a summary and remind the user to restart the shell (`exec zsh`).

## 1. Locate the repo

The repo must already exist — this skill lives inside it. Fresh-machine bootstrap (agent tool, clone, skill placement) is manual by necessity and is documented in the repo `README.md`; it is intentionally outside this skill.

Locate the root from this skill's own base directory (given at invocation; for Claude Code that is `~/.claude/skills/land`, a symlink into the repo): resolve it with `realpath`, then go up three levels — `.agents/skills/land` → repo root.

```bash
root=$(dirname "$(dirname "$(dirname "$(realpath ~/.claude/skills/land)")")")
```

If that fails, or the result does not contain this skill, try the cwd as a fallback. If neither works, stop and point the user to the README — do not clone or guess. Run all later steps from the repo root.

## 2. Prerequisites

Verify each of: `git curl wget gcc make tar cmake node`.

If any is missing, stop, tell the user which ones and the usual install command (Debian/Ubuntu package names), and re-check after they install. Do not attempt installs of prerequisites yourself unless asked.

## 3. Copy dotfiles

Copy everything from the repo root into `$HOME` **except** the excludes below:

- `.git`, `.ssh`, `.claude`, `.agents` — never copy (`.claude` would clobber the live `~/.claude`; `.agents` is consumed via symlinks in step 4, not copies)
- `*.json`, `*.md`, `*.mjs`, `*.bak` — machine-local or generated

```bash
for file in .[!.]* *; do
  case "$file" in
    .git|.ssh|.claude|.agents|*.json|*.md|*.mjs|*.bak) continue ;;
  esac
  [ -e "$file" ] && command cp -r "$file" ~/
done
find ~ -maxdepth 1 -name 'README.md*.mjs' -delete
```

Use `command cp` — a plain `cp` may be aliased to `cp -i` in the user's shell, which declines every overwrite when stdin is absent. Use `find … -delete` for the leftover cleanup — a bare `rm ~/README.md-*.mjs` aborts under zsh's `nomatch` when no file matches.

`keybindings.json`, `settings.json`, and `.luarc.json` are intentionally excluded — they are per-machine, copy them manually only if the user asks.

## 4. Link agent skills

Symlink every skill from the repo's `.agents/skills/` **directly** into `~/.claude/skills/` — no intermediate copies, so edits in the repo take effect immediately. This is the self-healing step: skills added to the repo later get linked on the next `/land` run. `land` itself is usually already linked (bootstrap), and the guard skips valid links; broken ones are replaced:

```bash
mkdir -p ~/.claude/skills
for skill in "$root/.agents/skills"/*; do
  [ -e "$skill" ] || continue
  name=$(basename "$skill")
  dest=~/.claude/skills/"$name"
  [ -e "$dest" ] && continue            # already linked — skip
  [ -L "$dest" ] && command rm -f "$dest"   # broken link — replace
  ln -s "$skill" "$dest"
done
```

## 5. Domains

Each sub-skill follows the same shape — guards first, steps in order, honest report.

| Domain  | Installs                                                                  |
| ------- | ------------------------------------------------------------------------ |
| git     | verifies `.gitconfig` applied, global excludes, git-lfs, pager            |
| zsh     | Oh My Zsh + autosuggestions + syntax-highlighting + powerlevel10k, fzf, z |
| node    | npm globals (commitizen, pm2, typescript, biome, vue/ts LSPs…), vue-ts5   |
| lua     | Lua 5.1.5 from source, lua-language-server                               |
| rust    | rustup + components, cargo tools (ripgrep, lsd, bat, fd, …)               |
| python  | uv                                                                       |
| font    | FiraCode Nerd Font                                                       |
| wasm    | wasmtime, wabt, wasi-sdk                                                 |

## 6. Report

Summarize per domain and per step: installed / skipped (already present) / failed. If a domain fails, continue with the remaining domains instead of aborting. Finish with: restart the shell (`exec zsh`) to pick up the new config.

## Conventions

Shared by all sub-skills:

- **Check before acting** — run each guard before installing; report "skipped" when it passes.
- **PATH additions go to `~/.exports.local`**, never to `.exports` (which is repo-managed). `~/.profile` sources `*.local` variants automatically. Append only if the line is not already present.
- **Announce sudo steps** (e.g. `make install` for Lua) before running them.
- Leave the machine as-is on failure — no rollback, just an honest report.
