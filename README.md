# My dotfiles and configs

Dotfiles and toolchain setup for my Linux machines. Setup is driven by the [`land`](.agents/skills/land/SKILL.md) skill — agent-friendly and idempotent.

## Quick start (new machine)

Bootstrap is manual by necessity — the skill that automates setup has to be placed by hand first:

1. **Prepare an agent tool**: [Claude Code](https://claude.com/claude-code) or any agent that can consume skills, plus `git`.
2. **Clone the repo** — any path you like:

   ```bash
   git clone git@github.com:EverSeenTOTOTO/config.git <repo>
   ```

3. **Place the skills** where your agent looks. They are tool-agnostic under `.agents/skills/` — for Claude Code, symlink at least `land`:

   ```bash
   cd <repo>
   mkdir -p ~/.claude/skills
   ln -s "$PWD/.agents/skills/land" ~/.claude/skills/land
   ```

4. **Run `/land`** from inside the repo (the skill detects it via the cwd, falling back to `~/repos/config`). It links the remaining skills, checks prerequisites, copies the dotfiles, and lets you pick which domains to install. Everything is idempotent — re-run any time, e.g. after pulling config changes.

## Skills

Three top-level skills live in [`.agents/skills/`](.agents/skills/), deployed by symlinking into `~/.claude/skills/`. One-liners here — details live in each `SKILL.md`:

- **`/land`** — machine bootstrap; `/land <domain>` runs a single domain
- **`/deploy`** — ship a project to the server: push 1dev, pull+build on the server, reload pm2
- **`/boot`** — boot script

## Layout

```text
.
├── .agents/skills/              # agent skills, tool-agnostic by design
│   ├── land/                    #   /land — machine bootstrap, one dir per domain
│   ├── deploy/                  #   /deploy — push 1dev, build on server, reload pm2
│   └── boot/                    #   /boot — boot script
├── .config/
│   ├── nvim/                    # full nvim distro (core/plugins/config)
│   └── pip/
├── .zshrc / .profile / .exports / .aliases    # shell
├── .vimrc / .tmux.conf / .inputrc             # terminal & editor
├── .gitconfig / .gitignore                    # git — repo .gitignore doubles as the global excludes file
├── .clang-format / .stylua.toml               # formatter styles
├── .bashrc / .npmrc / .yarnrc                 # tool defaults
├── .ssh/                        # never copied by /land
└── README.md
```

Notes:

- `~/.profile` also sources `~/.exports.local` etc. — machine-specific overrides live there, never in the repo
- `/land` symlinks every skill from the repo into `~/.claude/skills` — new skills get linked on the next `/land` run
- `keybindings.json`, `settings.json`, and `.luarc.json` are per-machine and are intentionally not copied by `/land`
