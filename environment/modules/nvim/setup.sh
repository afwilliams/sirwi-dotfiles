setup_module() {
  backup_existing "nvim" "$HOME/.config/nvim"
  printf 'Configuring Neovim...\n'
  copy_config "$repo_dir/config/nvim" "$HOME/.config/nvim"
}
