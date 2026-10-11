---
name: boot
description: Start personal boot-time services — pm2 apps (clash) and the pdf rsync to the remote — with a log trail. Run at machine start or on demand; each service is guarded and skips what is already running.
---

# Boot

The old `boot.js` (zx) as an agent skill — same actions, no zx dependency. `pm2` itself comes from the `node` domain of [`/land`](../land/SKILL.md).

## Workflow

1. Append a log header to `~/.cache/boot.log` (divider + `date`).
2. Start pm2 services — each guarded, skip what is already running.
3. Run the pdf rsync to the remote.

## pm2 services

### clash

Guard: `pm2 pid clash` returns a pid.

```bash
pm2 start -n clash "clash-party" --interpreter bash
```

Slots (disabled in the original script — re-enable when needed):

```bash
# pm2 start -n fcitx5 "fcitx5"
# pm2 start -n hidden "v2ray" -- run --config .config/v2ray/config-hidden.json
```

## pdf rsync

Run from `$HOME` (paths are relative to it, as in the original script). `$TSS` is the ssh destination, resolved from the environment:

```bash
rsync ./ftp/pdf/ "$TSS":~/ftp/pdf -azrv --progress --ignore-existing --exclude=".*" 2>&1 | tee -a ~/.cache/boot.log
```

Notes:

- `tee -a` (append) — the original `tee` truncated the log right after the header had been appended; appending matches the evident intent.
- Wiring this into systemd/cron autostart is outside the skill — it runs wherever an agent session is available.

## Report

Per service: started / skipped (already running) / failed. Show the last log lines on failure.
