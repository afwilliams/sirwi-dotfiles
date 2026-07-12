setup_module() {
  backup_existing "starship/starship.toml" "$HOME/.config/starship.toml"
  printf 'Configuring Starship...\n'

  if [ "$dry_run" = true ]; then
    printf '[dry-run] Would copy %s to %s\n' "$repo_dir/config/starship/starship.toml" "$HOME/.config/starship.toml"
  else
    mkdir -p "$HOME/.config"
    cp "$repo_dir/config/starship/starship.toml" "$HOME/.config/starship.toml"
  fi

  source "$repo_dir/environment/modules/starship/activate.sh"
  activate_starship
}
