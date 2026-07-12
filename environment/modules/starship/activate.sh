starship_shell_config() {
  local shell_name

  shell_name="$(basename "${SHELL:-}")"

  case "$shell_name" in
    bash) printf '%s\n' "$HOME/.bashrc" ;;
    zsh) printf '%s\n' "$HOME/.zshrc" ;;
    fish) printf '%s\n' "$HOME/.config/fish/config.fish" ;;
    *) return 1 ;;
  esac
}

starship_init_command() {
  local shell_name

  shell_name="$(basename "${SHELL:-}")"

  case "$shell_name" in
    bash) printf '%s\n' 'eval "$(starship init bash)"' ;;
    zsh) printf '%s\n' 'eval "$(starship init zsh)"' ;;
    fish) printf '%s\n' 'starship init fish | source' ;;
    *) return 1 ;;
  esac
}

activate_starship() {
  local shell_name
  local shell_config
  local init_command
  local marker="# sirwi-dotfiles: starship"

  shell_name="$(basename "${SHELL:-}")"

  if ! shell_config="$(starship_shell_config)" || ! init_command="$(starship_init_command)"; then
    printf 'Skipping Starship activation: unsupported shell %s.\n' "${shell_name:-unknown}"
    return 0
  fi

  if [ -f "$shell_config" ] && { grep -Fq "$marker" "$shell_config" || grep -Fq "starship init" "$shell_config"; }; then
    printf 'Starship is already enabled in %s.\n' "$shell_config"
    return 0
  fi

  backup_existing "starship/$(basename "$shell_config")" "$shell_config"
  printf 'Enabling Starship for %s in %s...\n' "$shell_name" "$shell_config"

  if [ "$dry_run" = true ]; then
    printf '[dry-run] Would append Starship init to %s\n' "$shell_config"
    return 0
  fi

  mkdir -p "$(dirname "$shell_config")"
  {
    printf '\n%s\n' "$marker"
    printf '%s\n' "$init_command"
  } >> "$shell_config"
}
