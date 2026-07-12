setup_module() {
  backup_existing "rofi" "$HOME/.config/rofi"
  printf 'Configuring Rofi...\n'
  copy_config "$repo_dir/config/rofi" "$HOME/.config/rofi"
  make_scripts_executable "$HOME/.config/rofi/scripts"
}
