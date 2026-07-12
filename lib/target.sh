setup_module_file_for() {
  case "$1" in
    lock) printf '%s\n' "$repo_dir/environment/modules/hyprlock/setup.sh" ;;
    *) printf '%s\n' "$repo_dir/environment/modules/$1/setup.sh" ;;
  esac
}

configure_module() {
  local target="$1"
  local module_setup

  module_setup="$(setup_module_file_for "$target")"

  if [ ! -f "$module_setup" ]; then
    printf 'Unknown target: %s\n' "$target" >&2
    usage
    exit 1
  fi

  unset -f setup_module 2>/dev/null || true
  source "$module_setup"

  if ! declare -F setup_module >/dev/null; then
    printf 'Module setup file does not define setup_module: %s\n' "$module_setup" >&2
    exit 1
  fi

  setup_module
}

configure_target() {
  local target="$1"

  install_target_packages "$target"

  case "$target" in
    base|wayland)
      printf 'Configured shared environment layer: %s\n' "$target"
      ;;
    *)
      configure_module "$target"
      ;;
  esac
}

configure_all() {
  local target
  local previous_packages_prepared="$packages_prepared"

  install_target_packages all
  packages_prepared=true

  while IFS= read -r target; do
    [ -z "$target" ] && continue
    case "$target" in \#*) continue ;; esac
    configure_target "$target"
  done < "$repo_dir/environment/all"

  packages_prepared="$previous_packages_prepared"
}

usage() {
  printf 'Usage: %s [--no-packages] [--dry-run] [all|wayland|btop|gimp|kitty|rofi|swaync|waybar|hypr|hyprlock|lock|nvim|mise|starship|clean-backups]\n' "$0"
}
