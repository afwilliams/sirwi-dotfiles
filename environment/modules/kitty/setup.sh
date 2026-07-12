setup_module() {
  backup_existing "kitty" "$HOME/.config/kitty"
  printf 'Configuring Kitty...\n'
  copy_config "$repo_dir/config/kitty" "$HOME/.config/kitty"
}
