#!/usr/bin/env bash

set -euo pipefail

action="${1:-status}"
icon="󰆧"
tooltip="Scratchpad: special:magic"

is_visible() {
  hyprctl monitors -j 2>/dev/null | jq -e 'any(.[]; .specialWorkspace.name == "special:magic")' >/dev/null 2>&1
}

hide_top_waybar() {
  pkill -SIGUSR1 waybar 2>/dev/null || true
}

show_top_waybar() {
  pkill -SIGUSR2 waybar 2>/dev/null || true
}

toggle_special() {
  if is_visible; then
    hyprctl dispatch 'hl.dsp.workspace.toggle_special("magic")' >/dev/null
    show_top_waybar
  else
    hide_top_waybar
    hyprctl dispatch 'hl.dsp.workspace.toggle_special("magic")' >/dev/null
  fi
}

case "$action" in
  status)
    ;;
  toggle)
    toggle_special
    ;;
  hide-top)
    hide_top_waybar
    ;;
  show-top)
    show_top_waybar
    ;;
  *)
    printf 'Unknown action: %s\n' "$action" >&2
    exit 2
    ;;
esac

if is_visible; then
  printf '{"text":"%s","tooltip":"%s abierto","class":["special-workspace","visible"]}\n' "$icon" "$tooltip"
else
  printf '{"text":"%s","tooltip":"%s","class":["special-workspace"]}\n' "$icon" "$tooltip"
fi
