copy_config() {
  local source_path="$1"
  local target_path="$2"

  if [ ! -d "$source_path" ]; then
    printf 'No config directory found at %s. Skipping config copy.\n' "$source_path"
    return
  fi

  if [ "$dry_run" = true ]; then
    printf '[dry-run] Would copy %s to %s\n' "$source_path" "$target_path"
    return
  fi

  mkdir -p "$target_path"
  cp -r "$source_path/." "$target_path/"
}

make_scripts_executable() {
  local scripts_dir="$1"

  if [ "$dry_run" = true ]; then
    printf '[dry-run] Would make scripts executable in %s\n' "$scripts_dir"
    return
  fi

  if compgen -G "$scripts_dir/*.sh" >/dev/null; then
    chmod +x "$scripts_dir/"*.sh
  fi
}
