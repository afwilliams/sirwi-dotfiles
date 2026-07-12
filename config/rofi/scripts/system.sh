#!/usr/bin/env bash

theme="$HOME/.config/rofi/themes/sirwi-system.rasi"

show_menu() {
  printf "%s" "$1" | rofi -dmenu -theme "$theme"
}

main_menu() {
  choice=$(show_menu "󰒓  System
󰂯  Bluetooth
󰖩  Internet
󰍹  Displays")

  case "$choice" in
    "󰒓  System")     system_menu ;;
    "󰂯  Bluetooth")
      rfkill unblock bluetooth
      kitty --class bluetooth-tui --title Bluetooth -e bluetui
      ;;
    "󰖩  Internet")
      rfkill unblock wifi
      kitty --class wifi-tui --title WiFi -e nmtui
      ;;
    "󰍹  Displays")   nwg-displays & ;;
    *) ;;
  esac
}

system_menu() {
  choice=$(show_menu "󰐥  Power off
󰑐  Restart
󰌾  Lock
󰒲  Suspend
󰗼  Exit
󰌑  Back")

  case "$choice" in
    "󰐥  Power off") systemctl poweroff ;;
    "󰑐  Restart")   systemctl reboot ;;
    "󰌾  Lock")      hyprlock ;;
    "󰒲  Suspend")
      hyprlock &
      sleep 0.5
      systemctl suspend
      ;;
    "󰗼  Exit")      hyprctl dispatch exit ;;
    "󰌑  Back")      main_menu ;;
    *) ;;
  esac
}

main_menu
