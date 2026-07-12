#!/usr/bin/env bash

set -euo pipefail

action="${1:-toggle}"

json() {
  printf '{"text":"%s","tooltip":"%s","class":%s}\n' "$1" "$2" "$3"
}

inactive() {
  json "" "" '["media","inactive"]'
}

player_base() {
  printf '%s\n' "${1%%.*}"
}

select_player() {
  local player status fallback=""

  command -v playerctl >/dev/null 2>&1 || return 1

  while IFS= read -r player; do
    [ -z "$player" ] && continue
    status="$(playerctl -p "$player" status 2>/dev/null || true)"
    case "$status" in
      Playing)
        printf '%s\n' "$player"
        return 0
        ;;
      Paused)
        [ -z "$fallback" ] && fallback="$player"
        ;;
    esac
  done < <(playerctl -l 2>/dev/null || true)

  [ -n "$fallback" ] || return 1
  printf '%s\n' "$fallback"
}

player_identity() {
  local player="$1"
  local identity

  identity="$(playerctl -p "$player" metadata --format '{{playerName}}' 2>/dev/null || true)"
  [ -n "$identity" ] || identity="$(player_base "$player")"
  printf '%s\n' "$identity"
}

source_icon() {
  case "$(player_base "$1")" in
    chromium|chrome|google-chrome) printf '' ;;
    firefox) printf '' ;;
    spotify) printf '' ;;
    vlc) printf '󰕼' ;;
    *) printf '󰝚' ;;
  esac
}

focus_class_for() {
  case "$(player_base "$1")" in
    chromium|chrome|google-chrome) printf 'google-chrome|chromium' ;;
    firefox) printf 'firefox' ;;
    spotify) printf 'Spotify|spotify' ;;
    vlc) printf 'vlc' ;;
    *) return 1 ;;
  esac
}

media_title() {
  playerctl -p "$1" metadata --format '{{title}}' 2>/dev/null || true
}

json_field() {
  local field="$1"

  if command -v jq >/dev/null 2>&1; then
    jq -r ".${field} // empty"
  elif command -v python3 >/dev/null 2>&1; then
    python3 -c 'import json,sys; data=json.load(sys.stdin); print(data.get(sys.argv[1], ""))' "$field"
  else
    return 1
  fi
}

window_address_for() {
  local class_pattern="$1"
  local title="$2"

  if command -v jq >/dev/null 2>&1; then
    hyprctl clients -j 2>/dev/null | jq -r --arg class_pattern "$class_pattern" --arg title "$title" '
      def class_match: (.class // "") | test($class_pattern);
      def title_match: ($title != "" and ((.title // "") | contains($title)));
      ((map(select(class_match and title_match)) | first) // (map(select(class_match)) | first) // {}) | .address // empty
    '
  elif command -v python3 >/dev/null 2>&1; then
    hyprctl clients -j 2>/dev/null | python3 -c '
import json, re, sys
class_pattern = sys.argv[1]
title = sys.argv[2]
clients = json.load(sys.stdin)
matches = [c for c in clients if re.search(class_pattern, c.get("class", ""))]
title_matches = [c for c in matches if title and title in c.get("title", "")]
selected = (title_matches or matches or [{}])[0]
print(selected.get("address", ""))
' "$class_pattern" "$title"
  else
    return 1
  fi
}

raise_player() {
  local player="$1"
  local service="org.mpris.MediaPlayer2.$player"
  local can_raise

  can_raise="$(busctl --user get-property "$service" /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2 CanRaise 2>/dev/null || true)"
  can_raise="${can_raise#b }"
  if [ "$can_raise" = "true" ]; then
    busctl --user call "$service" /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2 Raise >/dev/null 2>&1 && return 0
  fi

  return 1
}

focus_window() {
  local player="$1"
  local identity="$2"
  local class_pattern title address active_address

  if raise_player "$player"; then
    return 0
  fi

  if ! class_pattern="$(focus_class_for "$player")"; then
    notify-send "Media source" "No window mapping for $identity"
    return 1
  fi

  title="$(media_title "$player")"
  address="$(window_address_for "$class_pattern" "$title")"

  if [ -z "$address" ]; then
    notify-send "Media source" "No window found for $identity"
    return 1
  fi

  hyprctl dispatch "hl.dsp.focus({window=\"address:$address\"})" >/dev/null 2>&1 || true
  active_address="$(hyprctl activewindow -j 2>/dev/null | json_field address || true)"

  if [ "$active_address" = "$address" ]; then
    return 0
  fi

  notify-send "Media source" "Could not focus $identity"
  return 1
}

player="$(select_player || true)"
[ -n "$player" ] || { inactive; exit 0; }

status="$(playerctl -p "$player" status 2>/dev/null || true)"
identity="$(player_identity "$player")"

case "$action" in
  source)
    json "$(source_icon "$player")" "Focus $identity" '["media","source"]'
    ;;
  previous)
    json "󰒮" "Previous" '["media","previous"]'
    ;;
  next)
    json "󰒭" "Next" '["media","next"]'
    ;;
  toggle)
    if [ "$status" = "Playing" ]; then
      json "󰏤" "Pause" '["media","toggle","playing"]'
    else
      json "󰐊" "Play" '["media","toggle","paused"]'
    fi
    ;;
  focus)
    focus_window "$player" "$identity"
    ;;
  previous-action)
    playerctl -p "$player" previous
    ;;
  toggle-action)
    playerctl -p "$player" play-pause
    ;;
  next-action)
    playerctl -p "$player" next
    ;;
  *)
    exit 1
    ;;
esac
