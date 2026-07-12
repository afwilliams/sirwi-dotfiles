reload_waybar() {
  if [ "$dry_run" = true ]; then
    printf '[dry-run] Would reload Waybar.\n'
  elif command -v waybar >/dev/null 2>&1; then
    printf 'Reloading Waybar...\n'
    pkill waybar 2>/dev/null || true
    nohup waybar >/dev/null 2>&1 &
  else
    printf 'Skipping Waybar reload: waybar not found.\n'
  fi
}

reload_hypr() {
  if [ "$dry_run" = true ]; then
    printf '[dry-run] Would reload Hyprland.\n'
  elif command -v hyprctl >/dev/null 2>&1; then
    printf 'Reloading Hyprland...\n'
    hyprctl reload || printf 'Warning: hyprctl reload failed.\n' >&2
  else
    printf 'Skipping Hyprland reload: hyprctl not found.\n'
  fi
}

reload_hyprpaper() {
  if [ "$dry_run" = true ]; then
    printf '[dry-run] Would restart Hyprpaper.\n'
  elif command -v hyprpaper >/dev/null 2>&1; then
    printf 'Restarting Hyprpaper...\n'
    pkill hyprpaper 2>/dev/null || true
    nohup hyprpaper >/dev/null 2>&1 &
  else
    printf 'Skipping Hyprpaper restart: hyprpaper not found.\n'
  fi
}
