backup_existing() {
  local name="$1"
  local source_path="$2"
  local backup_path="$backup_dir/$name"

  if [ -e "$source_path" ]; then
    if [ "$dry_run" = true ]; then
      printf '[dry-run] Would back up %s to %s\n' "$source_path" "$backup_path"
      return
    fi

    printf 'Backing up %s...\n' "$source_path"
    mkdir -p "$(dirname "$backup_path")"
    cp -a "$source_path" "$backup_path"
    printf 'Backup saved to %s\n' "$backup_path"
  else
    printf 'Skipping backup for %s: no existing config found.\n' "$source_path"
  fi
}

clean_backups() {
  local backups_root="$HOME/.config/sirwi-dotfiles/backups"

  if [ -d "$backups_root" ]; then
    printf 'Removing backups from %s...\n' "$backups_root"
    if [ "$dry_run" = false ]; then
      rm -rf "$backups_root"
    fi
    printf 'Backups removed.\n'
  else
    printf 'No backups found.\n'
  fi
}
