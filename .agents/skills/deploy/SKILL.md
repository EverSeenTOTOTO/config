---
name: deploy
description: Deploy the current project (or a named one) to the TSS server — push to the Gitea remote (resolved by URL, not name), then pull and run `make deploy` on the server. Key auth only. All per-project deploy steps live in each repo's own `make deploy` target, never in this skill.
---

# Deploy

## Conventions

- Server is `$TSS` (exported in `~/.exports.local`), key auth, no password. Every ssh uses `-o BatchMode=yes`, and remote commands run via `bash -lc` so nvm-installed node/pm2 are on PATH.
- Layout mirrors local: the server copy lives at `~/repos/<dir>`. The dir usually equals the repo name, occasionally not (local `docs` → server `doc`). Locate it: try the exact name, else list `~/repos/` on the server and take the obvious match; confirm with the user if ambiguous.
- Source of truth is the Gitea hosted on TSS itself. Which remote **name** it carries varies per project — `1dev` (when `origin` is the GitHub mirror) or `origin` itself. Resolve by URL, never by name: the deploy remote is the one whose URL points at the Gitea (host `$TSS`, port 6611; `localhost:6611` seen from the server side). GitHub is the public mirror; deploys never read from it.
- **Every deployable repo defines `make deploy`** — the single canonical entry point, living in the project's own makefile. It owns everything project-specific: the build, and how the app comes back up (`pm2 reload` of a long-running server, `pm2 restart` of a build-in-start chain like doc's, artifact handling, first-time `pm2 start`…). It must be safe to re-run. This skill never encodes per-project details — when a repo lacks the target, add it to that repo, not here.

## Workflow

1. Resolve the project: the repo root of the cwd (or the name given as argument). Record the current rev — `git rev-parse --short HEAD` — as the "from" revision.
2. Resolve the deploy remote (local side): run `git remote -v` and pick the remote whose URL points at the TSS Gitea — usually named `1dev`, sometimes `origin`. Push the current branch to it (`git push <remote>`; the `p1` alias only applies when it is named `1dev`).
3. On the server: pull, then run the project's deploy target. Substitute `<dir>`, `<remote>`, `<branch>`:

```bash
ssh -o BatchMode=yes "$TSS" bash -lc '
  set -e
  cd ~/repos/<dir>
  git pull <remote> <branch>
  make deploy
'
```

4. Verify and report: `pm2 ls` shows the app online with fresh uptime; report the from→to revs; hit the entry URL if the project has one.

## Notes

- `git pull --ff-only` (the default in `.gitconfig`) fails loudly if the server copy drifted — on purpose. The server copy is disposable; inspect before force-resetting.
- Never pipe the pull through `tail`/`tee` without `set -o pipefail` — a failed pull (wrong remote name, drift) gets masked and `make deploy` runs on a stale tree. Battle scar: a server clone named its Gitea remote `origin`, the pull failed silently behind a pipe, and make reported "No rule to make target 'deploy'".
- Writing a `make deploy` for a new repo: typically `build + pm2 reload <name>` (zero-downtime for a long-running server) or `pm2 restart <name>` when the build lives inside the pm2 start chain; first-time apps need a one-off `pm2 start <cmd> --name <name>` before reload works.
- Long builds: run them in a **detached tmux session** instead of holding the ssh line — `ssh $TSS 'tmux new-session -d -s deploy-<name> "cd ~/repos/<dir> && make deploy"'`, then attach to watch or intervene with `ssh -t $TSS 'tmux a -t deploy-<name>'`. Unlike nohup, the output stays in a live terminal you can re-enter.
