setup_module() {
  backup_existing "waybar" "$HOME/.config/waybar"
  printf 'Configuring Waybar...\n'
  copy_config "$repo_dir/config/waybar" "$HOME/.config/waybar"
  make_scripts_executable "$HOME/.config/waybar/scripts"
  reload_waybar
}
