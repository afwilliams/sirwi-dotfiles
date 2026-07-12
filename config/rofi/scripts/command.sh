#!/usr/bin/env bash

theme="$HOME/.config/rofi/themes/sirwi-command.rasi"

cmd=$(rofi -dmenu -theme "$theme")

if [[ -n "$cmd" ]]; then
  bash -lc "$cmd" >/dev/null 2>&1 &
fi
