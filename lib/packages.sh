module_needs_wayland() {
  case "$1" in
    hypr|hyprlock|lock|rofi|swaync|waybar) return 0 ;;
    *) return 1 ;;
  esac
}

package_file_for() {
  case "$1" in
    base) printf '%s\n' "$repo_dir/environment/base/packages.arch" ;;
    wayland) printf '%s\n' "$repo_dir/environment/wayland/packages.arch" ;;
    lock) printf '%s\n' "$repo_dir/environment/modules/hyprlock/packages.arch" ;;
    *) printf '%s\n' "$repo_dir/environment/modules/$1/packages.arch" ;;
  esac
}

collect_package_files() {
  local target="$1"
  local package_file

  package_file="$(package_file_for base)"
  [ -f "$package_file" ] && printf '%s\n' "$package_file"

  if [ "$target" = "all" ]; then
    while IFS= read -r target; do
      [ -z "$target" ] && continue
      case "$target" in \#*) continue ;; esac
      collect_package_files "$target"
    done < "$repo_dir/environment/all"
    return
  fi

  if [ "$target" = "wayland" ] || module_needs_wayland "$target"; then
    package_file="$(package_file_for wayland)"
    [ -f "$package_file" ] && printf '%s\n' "$package_file"
  fi

  if [ "$target" != "base" ] && [ "$target" != "wayland" ]; then
    package_file="$(package_file_for "$target")"
    [ -f "$package_file" ] && printf '%s\n' "$package_file"
  fi
}

install_target_packages() {
  local target="$1"
  local packages_file
  local package_file

  if [ "$packages_prepared" = true ]; then
    return
  fi

  packages_file="$(mktemp)"

  while IFS= read -r package_file; do
    sed '/^$/d; /^#/d' "$package_file" >> "$packages_file"
  done < <(collect_package_files "$target")

  sort -u -o "$packages_file" "$packages_file"

  if [ ! -s "$packages_file" ]; then
    rm -f "$packages_file"
    return
  fi

  if [ "$install_packages" = false ]; then
    printf 'Skipping package installation for %s.\n' "$target"
    rm -f "$packages_file"
    return
  fi

  printf 'Preparing packages for %s...\n' "$target"
  if [ "$dry_run" = true ]; then
    sed 's/^/  /' "$packages_file"
  else
    sudo pacman -S --needed - < "$packages_file"
  fi

  rm -f "$packages_file"
}
