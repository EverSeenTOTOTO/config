# git — config, lfs, pager

`.gitconfig` itself is applied by the dotfiles step of the [core workflow](../SKILL.md); this sub-skill verifies the git environment and fills the gaps.

## Guards

```bash
git config --global user.name        # non-empty
[ -f ~/.gitignore ]                  # core.excludesfile target (repo .gitignore doubles as it)
git lfs version                      # .gitconfig declares lfs filters
command -v git-split-diffs           # pager — an npm global
```

## Steps

- `user.name` empty → the dotfiles copy missed `.gitconfig`; re-run core workflow step 3.
- `~/.gitignore` missing → copy the repo's `.gitignore` to `$HOME` (it doubles as the global excludes file referenced by `core.excludesfile`).
- `git lfs version` fails → install per distro (Debian/Ubuntu: `sudo apt install git-lfs`, then `git lfs install`) — announce the sudo step.
- `git-split-diffs` missing → don't install here; report that the [node](../node/SKILL.md) sub-skill provides it (`/land node`).
