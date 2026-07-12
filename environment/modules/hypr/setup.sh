setup_module() {
  local local_display_files="monitors.lua workspaces.lua monitors.conf workspaces.conf"
  local preserve_dir=""

  backup_existing "hypr" "$HOME/.config/hypr"

  if [ "$dry_run" = true ]; then
    for file in $local_display_files; do
      if [ -e "$HOME/.config/hypr/$file" ]; then
        printf '[dry-run] Would keep existing local Hyprland display layout %s; it would not be replaced.\n' "$HOME/.config/hypr/$file"
      fi
    done
  elif [ -d "$HOME/.config/hypr" ]; then
    preserve_dir="$(mktemp -d)"
    for file in $local_display_files; do
      if [ -e "$HOME/.config/hypr/$file" ]; then
        printf 'Keeping existing local Hyprland display layout %s; it will not be replaced.\n' "$HOME/.config/hypr/$file"
        cp "$HOME/.config/hypr/$file" "$preserve_dir/$file"
      fi
    done
  fi

  printf 'Configuring Hyprland...\n'
  copy_config "$repo_dir/config/hypr" "$HOME/.config/hypr"

  if [ -n "$preserve_dir" ]; then
    for file in $local_display_files; do
      if [ -e "$preserve_dir/$file" ]; then
        cp "$preserve_dir/$file" "$HOME/.config/hypr/$file"
      fi
    done
    rm -rf "$preserve_dir"
  fi

  reload_hypr
  reload_hyprpaper
}
