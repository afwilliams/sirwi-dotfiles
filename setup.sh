#!/usr/bin/env bash

set -euo pipefail

repo_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
backup_dir="${SIRWI_BACKUP_DIR:-$HOME/.config/sirwi-dotfiles/backups/$(date +%Y%m%d-%H%M%S)}"
install_packages=true
dry_run=false
packages_prepared=false
target="all"

source "$repo_dir/lib/backup.sh"
source "$repo_dir/lib/config.sh"
source "$repo_dir/lib/reload.sh"
source "$repo_dir/lib/packages.sh"
source "$repo_dir/lib/target.sh"

while [ "$#" -gt 0 ]; do
  case "$1" in
    --no-packages)
      install_packages=false
      ;;
    --dry-run)
      dry_run=true
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      target="$1"
      ;;
  esac
  shift
done

case "$target" in
  all)
    configure_all
    ;;
  clean-backups)
    clean_backups
    ;;
  *)
    configure_target "$target"
    ;;
esac

printf 'Setup complete.\n'
