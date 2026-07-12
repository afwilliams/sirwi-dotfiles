#!/usr/bin/env bash

if bluetoothctl show 2>/dev/null | grep -q "Powered: yes"; then
  printf '{"text":"󰂱","class":"on"}\n'
elif bluetoothctl show 2>/dev/null | grep -q "Powered: no"; then
  printf '{"text":"󰂲","class":"off"}\n'
else
  printf '{"text":"󰂯","class":"unknown"}\n'
fi
