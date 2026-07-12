#!/usr/bin/env bash

set -euo pipefail

config="${XDG_CONFIG_HOME:-$HOME/.config}/waybar/cava.conf"
animation_ms=300
bars=16
last_player_check=0
has_playing=false
silent_since=0
state="hidden"
state_since=0
last_line="0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0"

json() {
  printf '{"text":"%s","tooltip":"%s","class":%s}\n' "$1" "$2" "$3"
}

inactive() {
  json "" "" '["audio-visualizer","inactive"]'
}

has_playing_player() {
  local player

  command -v playerctl >/dev/null 2>&1 || return 1

  while IFS= read -r player; do
    [ -z "$player" ] && continue
    [ "$(playerctl -p "$player" status 2>/dev/null || true)" = "Playing" ] && return 0
  done < <(playerctl -l 2>/dev/null || true)

  return 1
}

level_glyph() {
  case "$1" in
    0) printf '▁' ;;
    1) printf '▂' ;;
    2) printf '▃' ;;
    3) printf '▄' ;;
    4) printf '▅' ;;
    5) printf '▆' ;;
    6|7) printf '▇' ;;
    *) printf '█' ;;
  esac
}

frame_text() {
  local line="$1"
  local value text=""

  IFS=';' read -r -a values <<< "$line"
  for value in "${values[@]}"; do
    [[ "$value" =~ ^[0-9]+$ ]] || value=0
    text="${text}$(level_glyph "$value")"
  done

  printf '%s\n' "$text"
}

animated_frame_text() {
  local line="$1"
  local visible_bars="$2"
  local left right index value text=""

  left=$(((bars - visible_bars) / 2))
  right=$((left + visible_bars - 1))

  IFS=';' read -r -a values <<< "$line"
  for ((index = 0; index < bars; index++)); do
    if [ "$visible_bars" -gt 0 ] && [ "$index" -ge "$left" ] && [ "$index" -le "$right" ]; then
      value="${values[$index]:-0}"
      [[ "$value" =~ ^[0-9]+$ ]] || value=0
      text="${text}$(level_glyph "$value")"
    else
      text="${text} "
    fi
  done

  printf '%s\n' "$text"
}

animation_step() {
  local elapsed="$1"
  local step

  [ "$elapsed" -ge "$animation_ms" ] && { printf '%s\n' "$bars"; return; }

  step=$(((elapsed * bars / animation_ms) + 1))
  [ "$step" -le "$bars" ] || step="$bars"
  printf '%s\n' "$step"
}

emit_state() {
  local class="$1"
  local text="$2"

  json "$text" "Audio visualizer" "[\"audio-visualizer\",\"$class\"]"
}

frame_is_silent() {
  local line="$1"
  local value

  IFS=';' read -r -a values <<< "$line"
  for value in "${values[@]}"; do
    [[ "$value" =~ ^[0-9]+$ ]] || value=0
    [ "$value" -gt 0 ] && return 1
  done

  return 0
}

command -v cava >/dev/null 2>&1 || { inactive; exit 0; }
[ -f "$config" ] || { inactive; exit 0; }

inactive

cava -p "$config" 2>/dev/null | while IFS= read -r line; do
  now_ms="$(date +%s%3N)"
  target_visible=true
  elapsed=0
  step=0

  if [ "$((now_ms - last_player_check))" -ge 200 ]; then
    if has_playing_player; then
      has_playing=true
    else
      has_playing=false
    fi
    last_player_check="$now_ms"
  fi

  if [ "$has_playing" != true ]; then
    silent_since=0
    target_visible=false
  elif frame_is_silent "$line"; then
    [ "$silent_since" -ne 0 ] || silent_since="$now_ms"
    if [ "$((now_ms - silent_since))" -ge 1000 ]; then
      target_visible=false
    fi
  else
    silent_since=0
    last_line="$line"
  fi

  if [ "$target_visible" = true ]; then
    case "$state" in
      hidden|exiting)
        state="entering"
        state_since="$now_ms"
        ;;
    esac
  else
    case "$state" in
      entering|active)
        state="exiting"
        state_since="$now_ms"
        ;;
    esac
  fi

  case "$state" in
    entering)
      elapsed=$((now_ms - state_since))
      step="$(animation_step "$elapsed")"
      if [ "$step" -ge "$bars" ]; then
        state="active"
        emit_state "active" "$(frame_text "$line")"
      else
        emit_state "entering" "$(animated_frame_text "$line" "$step")"
      fi
      ;;
    active)
      emit_state "active" "$(frame_text "$line")"
      ;;
    exiting)
      elapsed=$((now_ms - state_since))
      step="$(animation_step "$elapsed")"
      if [ "$step" -ge "$bars" ]; then
        state="hidden"
        inactive
      else
        emit_state "exiting" "$(animated_frame_text "$last_line" "$((bars - step))")"
      fi
      ;;
    hidden)
      ;;
    *)
      state="hidden"
      inactive
      ;;
  esac
done
