#!/bin/bash
# Keeps macOS awake (caffeinate -i) while Claude Code is working.
# Usage: caffeinate.sh start|stop   (hook JSON on stdin; uses session_id)
set -u
input=$(cat)
sid=$(printf '%s' "$input" | jq -r '.session_id // "default"' 2>/dev/null)
sid=${sid:-default}
pidfile="${TMPDIR:-/tmp}/claude-caffeinate-${sid}.pid"

case "${1:-}" in
  start)
    if [ -f "$pidfile" ] && kill -0 "$(cat "$pidfile")" 2>/dev/null; then
      exit 0   # already awake for this session
    fi
    # Tie caffeinate to the Claude process so it dies with it, if the parent is Claude.
    parent_cmd=$(ps -o comm= -p "$PPID" 2>/dev/null)
    if printf '%s' "$parent_cmd" | grep -qiE 'claude|node|bun'; then
      nohup caffeinate -i -w "$PPID" >/dev/null 2>&1 &
    else
      nohup caffeinate -i >/dev/null 2>&1 &
    fi
    echo $! > "$pidfile"
    ;;
  stop)
    if [ -f "$pidfile" ]; then
      kill "$(cat "$pidfile")" 2>/dev/null
      rm -f "$pidfile"
    fi
    ;;
esac
exit 0
