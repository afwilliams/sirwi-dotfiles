# sirwi-dotfiles

![sirwi-room](config/hypr/assets/wallpapers/sirwi-room.png)

Personal Arch + Hyprland desktop dotfiles for Btop, GIMP, Rofi, Waybar, Hyprland, Neovim, Starship and related utility scripts.

## Contents

- Rofi launcher, applets and themes.
- Waybar config, styles and Bluetooth status script.
- SwayNotificationCenter config with Waybar status integration.
- Complete Hyprland Lua config, hyprlock, hyprpaper and assets.
- LazyVim-based Neovim config.
- Starship prompt config and shell activation.
- Btop installation through the environment setup.
- GIMP installation through the environment setup.
- Environment setup with packages separated by shared layer and module.

## Keybinds

- `SUPER + SPACE`: Rofi launcher with `Apps`, `Files` and `Commands` modes.
- `SUPER + N`: opens the SwayNotificationCenter panel.
- `SUPER + SHIFT + N`: toggles Do Not Disturb.
- `SUPER + SHIFT + X`: free command runner.
- `SUPER + X`: system menu.

## Waybar Integrations

- Bluetooth icon opens `bluetui` in `kitty`.
- Network icon opens `nmtui` in `kitty`.
- Bluetooth icon updates every second based on adapter power state.
- Notification icon opens SwayNotificationCenter and right-click toggles Do Not Disturb.

## Setup

From the repo root:

```bash
./setup.sh
./setup.sh all
./setup.sh wayland
./setup.sh btop
./setup.sh gimp
./setup.sh rofi
./setup.sh swaync
./setup.sh waybar
./setup.sh hypr
./setup.sh hyprlock
./setup.sh kitty
./setup.sh nvim
./setup.sh mise
./setup.sh starship
./setup.sh clean-backups
```

The setup prepares the selected part of the Linux environment. It installs the required Arch packages for that target, copies files into `~/.config`, and creates backups before replacing existing configs.

Use `--no-packages` when you only want to copy configs:

```bash
./setup.sh waybar --no-packages
```

Preview what would happen without changing the system:

```bash
./setup.sh hypr --dry-run
```

Targets:

- `all`: configures the complete current environment. This is also the default when no target is passed.
- `wayland`: prepares the shared Wayland layer used by the graphical environment.
- `btop`: installs Btop. No Btop config is tracked yet.
- `gimp`: installs GIMP. No GIMP config is tracked yet.
- `kitty`: installs Kitty and its visual configuration.
- `rofi`: installs Rofi config and scripts.
- `swaync`: installs SwayNotificationCenter config and restarts SwayNotificationCenter.
- `waybar`: installs Waybar config/scripts and restarts Waybar.
- `hypr`: installs Hyprland config/assets, reloads Hyprland and restarts Hyprpaper.
- `hyprlock` or `lock`: installs `hyprlock.conf`, lock wallpapers and avatar. It does not run `hyprlock`.
- `nvim`: installs LazyVim-based Neovim config.
- `mise`: installs mise. No mise config is tracked yet.
- `starship`: installs Starship prompt config and enables it for the detected shell.
- `clean-backups`: removes installer backups.

The lock screen uses the same wallpaper folder as Hyprpaper:

```text
config/hypr/assets/wallpapers/
```

## Backups

Before installing, the installer backs up existing configs to:

```text
~/.config/sirwi-dotfiles/backups/YYYYMMDD-HHMMSS/
```

When running `./setup.sh all`, all backups are grouped under the same timestamp.

Remove all generated backups with:

```bash
./setup.sh clean-backups
```

## Environment Structure

Packages are not managed as one large list anymore. They are separated by environment layer and module:

```text
environment/
├── all
├── base/
│   └── packages.arch
├── wayland/
│   └── packages.arch
└── modules/
    ├── btop/
    │   ├── packages.arch
    │   └── setup.sh
    ├── gimp/
    │   ├── packages.arch
    │   └── setup.sh
    ├── hypr/
    │   ├── packages.arch
    │   └── setup.sh
    ├── hyprlock/
    │   ├── packages.arch
    │   └── setup.sh
    ├── kitty/
    │   ├── packages.arch
    │   └── setup.sh
    ├── mise/
    │   ├── packages.arch
    │   └── setup.sh
    ├── nvim/
    │   ├── packages.arch
    │   └── setup.sh
    ├── rofi/
    │   ├── packages.arch
    │   └── setup.sh
    ├── swaync/
    │   ├── packages.arch
    │   └── setup.sh
    ├── starship/
    │   ├── packages.arch
    │   ├── setup.sh
    │   └── activate.sh
    └── waybar/
        ├── packages.arch
        └── setup.sh
```

- `environment/base`: packages always included for any setup target.
- `environment/wayland`: shared packages for the Wayland session.
- `environment/modules/<name>/packages.arch`: minimal packages for one module.
- `environment/modules/<name>/setup.sh`: setup steps for one module.
- `environment/all`: list of targets that compose the full current environment.
- `lib/`: shared setup helpers for backups, config copying, package resolution and reloads.

To add a module, create `environment/modules/<name>/packages.arch`, create `environment/modules/<name>/setup.sh` with a `setup_module` function, and add the module name to `environment/all` if it belongs to the full environment.

## Reload

Reloads are handled automatically by the installer where needed. Manual fallback commands:

```bash
hyprctl reload
pkill waybar && waybar &
pkill hyprpaper && hyprpaper &
```

## OpenCode Skills

This repo includes an OpenCode skill for preserving the Rofi visual language:

```text
.opencode/skills/rofi-style/SKILL.md
```

Restart OpenCode after changing skills so the running session can load them.

## Hyprland

Hyprland config lives in:

```text
config/hypr/
```

It includes the full Lua config, `hyprlock.conf`, `hyprpaper.conf` and assets.

## Neovim

Neovim config lives in:

```text
config/nvim/
```

It starts from a minimal LazyVim setup and is intended to grow gradually.
