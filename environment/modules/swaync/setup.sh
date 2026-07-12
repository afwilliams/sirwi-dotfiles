setup_module() {
  backup_existing "swaync" "$HOME/.config/swaync"
  printf 'Configuring SwayNotificationCenter...\n'
  copy_config "$repo_dir/config/swaync" "$HOME/.config/swaync"

  if [ "$dry_run" = true ]; then
    printf '[dry-run] Would stop Mako before starting SwayNotificationCenter.\n'
    printf '[dry-run] Would restart SwayNotificationCenter.\n'
  elif command -v swaync >/dev/null 2>&1; then
    printf 'Restarting SwayNotificationCenter...\n'
    pkill mako 2>/dev/null || true
    pkill swaync 2>/dev/null || true
    nohup swaync >/dev/null 2>&1 &
  else
    printf 'Skipping SwayNotificationCenter restart: swaync not found.\n'
  fi
}
