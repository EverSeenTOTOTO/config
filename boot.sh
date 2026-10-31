#!/usr/bin/env bash
# boot — personal boot-time services.
#
#   1. pm2 apps (clash)   — skipped when already online
#   2. pdf rsync to $TSS  — --ignore-existing, never deletes
#
# Idempotent and safe to re-run. Everything is logged to ~/.cache/boot.log.
# Run by hand (`boot`) or from session autostart (WM exec line / systemd user
# unit) — the script bootstraps its own environment, no login shell needed.
set -uo pipefail

LOG="$HOME/.cache/boot.log"
mkdir -p "$HOME/.cache"

failures=0

log() { printf '[%s] %s\n' "$(date '+%F %T')" "$*" | tee -a "$LOG"; }
fail() { log "FAIL: $*"; failures=$((failures + 1)); }

# --- log header (the old divider + date format) --------------------------------
printf '%s\n' '----------------------------------------------------' >>"$LOG"
date >>"$LOG"

# --- environment ------------------------------------------------------------
# Under session autostart neither $TSS (from ~/.exports.local) nor nvm's pm2
# is on the environment — pull them in.
if [ -z "${TSS:-}" ] && [ -r "$HOME/.exports.local" ]; then
	. "$HOME/.exports.local"
fi
if ! command -v pm2 >/dev/null 2>&1; then
	for bin in "$HOME"/.nvm/versions/node/*/bin; do
		[ -x "$bin/pm2" ] && PATH="$bin:$PATH" && break
	done
fi

# --- pm2 services -------------------------------------------------------------
# pm2_service <name> <script> — start under pm2 unless already online.
# The guard checks the printed pid, not the exit code: when the pm2 daemon is
# down, `pm2 pid` spawns it, exits 0, and prints its banner to stdout.
pm2_service() {
	local name=$1 script=$2 pid
	pid=$(pm2 pid "$name" 2>/dev/null)
	if [[ $pid =~ ^[0-9]+$ ]]; then
		log "pm2 $name: skipped (already running, pid $pid)"
	elif pm2 start -n "$name" "$script" --interpreter bash >>"$LOG" 2>&1; then
		log "pm2 $name: started"
	else
		fail "pm2 $name: pm2 start exited $?"
	fi
}

pm2_service clash clash-party
# pm2_service fcitx5 fcitx5
# pm2 start -n hidden v2ray -- run --config "$HOME/.config/v2ray/config-hidden.json"

# --- pdf rsync ----------------------------------------------------------------
pdf_rsync() {
	if [ -z "${TSS:-}" ]; then
		fail "pdf rsync: \$TSS is not set (define it in ~/.exports.local)"
	elif [ ! -d "$HOME/ftp/pdf" ]; then
		fail "pdf rsync: ~/ftp/pdf does not exist"
	elif rsync "$HOME/ftp/pdf/" "$TSS:~/ftp/pdf" \
		-azrv --progress --ignore-existing --exclude='.*' \
		-e 'ssh -o ConnectTimeout=15' 2>&1 | tee -a "$LOG"; then
		log "pdf rsync: done"
	else
		fail "pdf rsync: exited $?"
	fi
}

pdf_rsync

# --- summary -------------------------------------------------------------------
log "boot finished with $failures failure(s)"
exit "$failures"
