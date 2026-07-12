setup_module() {
  backup_existing "lock/hyprlock.conf" "$HOME/.config/hypr/hyprlock.conf"
  backup_existing "lock/wallpapers" "$HOME/.config/hypr/assets/wallpapers"
  backup_existing "lock/sir-williams-avatar.png" "$HOME/.config/hypr/assets/sir-williams-avatar.png"
  printf 'Configuring lock screen...\n'

  if [ "$dry_run" = true ]; then
    printf '[dry-run] Would copy Hyprlock config and assets.\n'
    return
  fi

  mkdir -p "$HOME/.config/hypr/assets"
  cp "$repo_dir/config/hypr/hyprlock.conf" "$HOME/.config/hypr/hyprlock.conf"
  cp -r "$repo_dir/config/hypr/assets/wallpapers" "$HOME/.config/hypr/assets/"
  cp "$repo_dir/config/hypr/assets/sir-williams-avatar.png" "$HOME/.config/hypr/assets/sir-williams-avatar.png"
}
