---
name: environment-module-structure
description: Use when the user wants to create or modify a sirwi-dotfiles environment module, add application configuration, add packages, create setup support for a tool, or change files under environment/, config/, lib/, setup.sh, README module documentation, or installer targets. Interpret equivalent requests in any language as module work.
---

# Environment Module Structure

Use this skill when adding or changing Linux environment setup modules in `sirwi-dotfiles`.

## Language Handling

The user may describe module work in any language. Infer the intent semantically instead of relying only on literal English trigger phrases.

Treat requests equivalent to creating a module, adding application configuration, installing support for an application, adding packages for a tool, or creating setup support as environment module work, even when the user writes the request in another language.

Keep skill-driven code, file names, technical comments, README additions, and module documentation in English unless the user explicitly asks for another language.

## Intent Recognition

Default to this skill when the request is about any of these intents:

- Create a new setup module for an application or tool.
- Add tracked configuration for an application.
- Add package installation support for an application.
- Add a new target usable through `./setup.sh <target>`.
- Change how `./setup.sh all` composes the full environment.
- Add, move, or classify packages under `environment/base`, `environment/wayland`, or `environment/modules`.
- Change files under `environment/`, `config/`, `lib/`, `setup.sh`, or module-related README sections.

If the user asks for application configuration such as editor settings, terminal settings, desktop utilities, launchers, status bars, lock screens, daemons, or CLI tool setup, first evaluate whether it should be represented as a module.

Do not use this skill for unrelated application code outside the dotfiles environment.

## Core Principle

This repository configures a Linux working environment. Package installation is required, but it is an implementation detail. The user-facing concept is environment setup, not package management.

Keep `setup.sh` small. Do not add application-specific setup logic directly to `setup.sh`. New applications should be added as modules under `environment/modules/`.

## Current Architecture

Relevant paths:

- `setup.sh`: entrypoint, argument parsing, and top-level dispatch only.
- `lib/backup.sh`: backup helpers.
- `lib/config.sh`: config-copying helpers.
- `lib/packages.sh`: package resolution and installation helpers.
- `lib/reload.sh`: reload helpers for runtime services.
- `lib/target.sh`: target resolution and module loading.
- `environment/all`: list of targets that compose the full current environment.
- `environment/base/packages.arch`: packages included for every setup target.
- `environment/wayland/packages.arch`: shared packages for the Wayland session.
- `environment/modules/<name>/packages.arch`: minimal package list for one module.
- `environment/modules/<name>/setup.sh`: setup steps for one module.
- `config/<name>/`: tracked dotfiles copied into `~/.config/<name>` when the module has config.

## Required Discovery Workflow

Before writing code for a module request, inspect the repo enough to answer these questions:

- Does `environment/modules/<name>/` already exist?
- Does `config/<name>/` already exist, or does the application use a different runtime config path?
- Is the request a new module, a change to an existing module, a shared package change, a config-only change, or documentation-only work?
- Which Arch packages are required, and are they app-specific or shared?
- Does the module need the shared Wayland layer through `module_needs_wayland`?
- Should the module be included in `environment/all`, or should it remain an opt-in target?
- Does the module need backups, config copying, executable scripts, reload behavior, service enablement, or a custom destination path?
- Does the README need user-facing target documentation?

Ask one short clarification question only when the repo and request do not provide enough information to choose safely. Examples include whether an optional app should be part of `./setup.sh all`, or whether a non-standard config path is desired.

## Module Decision Tree

Use this order when deciding where work belongs:

- If the request adds a user-callable target, create or update `environment/modules/<name>/`.
- If it adds files that should be installed under `~/.config`, put source files under `config/<name>/` by default.
- If the application uses a non-default runtime config path, keep source files in the most understandable repo location and make the destination explicit in the module setup script.
- If only packages are needed and no config is tracked yet, still create a package-only module.
- If the package is required for every possible target, put it in `environment/base/packages.arch`.
- If the package is shared by multiple graphical Wayland modules and does not belong to one application, put it in `environment/wayland/packages.arch`.
- If the package is needed by exactly one application, put it in that application's `environment/modules/<name>/packages.arch`.
- If multiple modules need the same helper logic, consider `lib/`; otherwise keep module-specific behavior inside `environment/modules/<name>/setup.sh`.

## Adding A New Application

For a new application named `<name>`, create:

```text
environment/modules/<name>/
├── packages.arch
└── setup.sh
```

If the application has tracked config, also create:

```text
config/<name>/
```

Only add the module to `environment/all` if it belongs to the complete default environment configured by `./setup.sh all`.

## Module Package Rules

`environment/modules/<name>/packages.arch` should contain the minimal packages needed for that module.

Identify packages from the application name, existing repo conventions, Arch package naming, and the requested behavior. When uncertain, verify package names with the available system/package tools or ask the user before writing an incorrect package list.

Package files should contain one package per line, with no comments unless an existing file already uses comments. Keep package lists minimal and deterministic.

Good example for Kitty:

```text
kitty
```

Bad example for Kitty:

```text
kitty
waybar
hyprland
rofi
```

Do not put another application's dependencies into the current module just because the current config can launch that other application. Prefer the smallest correct package set.

Examples:

- A Visual Studio Code module should usually include the editor package in the module package list, not in `base`.
- A launcher module should include the launcher package in its own module, but shared Wayland session support stays in `environment/wayland`.
- A terminal-only CLI tool belongs in its own module unless it is truly required by every target.
- A package used only by scripts inside one module belongs to that module, even if the script can be triggered from another application.

## Shared Package Layers

Use `environment/base/packages.arch` only for packages that should always be included for any target.

Examples:

```text
git
```

Use `environment/wayland/packages.arch` for packages that are shared by the Wayland session and do not belong cleanly to one application module.

Examples:

```text
pipewire
pipewire-pulse
wireplumber
xdg-desktop-portal-hyprland
polkit-kde-agent
wl-clipboard
mako
```

If a package is only needed by one app, keep it in that app's module.

Avoid promoting packages upward too early. A package should move from a module to `wayland` or `base` only when there is a concrete shared requirement, not because it might be useful later.

## Wayland Dependencies

Some modules require the Wayland layer automatically. This is controlled by `module_needs_wayland` in `lib/packages.sh`.

If adding a graphical Wayland-dependent module, update that function:

```bash
module_needs_wayland() {
  case "$1" in
    hypr|hyprlock|lock|rofi|waybar|new-module) return 0 ;;
    *) return 1 ;;
  esac
}
```

Do not add non-graphical or terminal-only tools to the Wayland dependency list unless they truly require the Wayland session layer.

## Module Setup Script

Every module setup file must define a `setup_module` function.

Use the smallest setup script that correctly handles the module. Do not add empty backups, empty config directories, reloads, or service logic unless the module actually needs them.

Package-only module:

```bash
setup_module() {
  printf 'Configured New App packages. No New App config is tracked yet.\n'
}
```

Basic config-copying module:

```bash
setup_module() {
  backup_existing "mako" "$HOME/.config/mako"
  printf 'Configuring Mako...\n'
  copy_config "$repo_dir/config/mako" "$HOME/.config/mako"
}
```

Module with executable scripts:

```bash
setup_module() {
  backup_existing "example" "$HOME/.config/example"
  printf 'Configuring Example...\n'
  copy_config "$repo_dir/config/example" "$HOME/.config/example"
  make_scripts_executable "$HOME/.config/example/scripts"
}
```

Module with reload behavior:

```bash
setup_module() {
  backup_existing "waybar" "$HOME/.config/waybar"
  printf 'Configuring Waybar...\n'
  copy_config "$repo_dir/config/waybar" "$HOME/.config/waybar"
  make_scripts_executable "$HOME/.config/waybar/scripts"
  reload_waybar
}
```

Module with custom destination path:

```bash
setup_module() {
  backup_existing "example" "$HOME/.config/example-custom"
  printf 'Configuring Example...\n'
  copy_config "$repo_dir/config/example" "$HOME/.config/example-custom"
}
```

Module that installs selected files from another config tree:

```bash
setup_module() {
  backup_existing "example" "$HOME/.config/example/example.conf"
  printf 'Configuring Example...\n'

  if [ "$dry_run" = true ]; then
    printf '[dry-run] Would install example.conf to %s\n' "$HOME/.config/example/example.conf"
    return 0
  fi

  mkdir -p "$HOME/.config/example"
  cp "$repo_dir/config/shared/example.conf" "$HOME/.config/example/example.conf"
}
```

When adding raw file operations such as `mkdir`, `cp`, `chmod`, or service commands, preserve `--dry-run` behavior explicitly if the helper does not already handle it.

Prefer existing helpers:

- `backup_existing` before replacing existing runtime config.
- `copy_config` for directory-to-directory config installs.
- `make_scripts_executable` for installed shell scripts.
- Reload helpers from `lib/reload.sh` when an existing helper matches the service.

Do not invent a reusable helper until at least two modules need the same behavior.

## Setup Script Rules

- Keep `setup.sh` as an entrypoint only.
- Do not add `install_<app>` functions to `setup.sh`.
- Do not add app-specific copy, chmod, or reload logic to `setup.sh`.
- Put reusable helpers in `lib/` only when at least two modules need them.
- Keep one-off app behavior inside `environment/modules/<name>/setup.sh`.
- Preserve `--dry-run` behavior whenever adding new file operations.
- Preserve `--no-packages` behavior by relying on the existing package pipeline.

## Config Placement

Use this mapping by default:

```text
config/<name>/ -> ~/.config/<name>/
```

If a module needs to install only part of another config tree, keep that special behavior inside the module setup file and make the backup paths explicit.

Example: `hyprlock` installs selected files from `config/hypr/`, so its logic belongs in `environment/modules/hyprlock/setup.sh`, not in `setup.sh`.

For applications with non-standard config locations, choose the clearest repo source path and document the install destination in the setup script. Do not force everything into the default mapping if the runtime application expects another path.

Common patterns:

- Standard XDG app: `config/<name>/` installs to `~/.config/<name>/`.
- Application-specific nested config: keep a clear source tree under `config/<name>/` and copy it to the required runtime path.
- Partial shared config: source may live under another tracked config tree, but the module setup must copy only the required files and back up the exact destination.
- Package-only app: no `config/<name>/` is required until actual tracked config exists.

When adding editor or GUI application settings, first check the application's real Linux config path. If there is ambiguity between upstream naming and package naming, prefer the runtime config path for the installed destination and a readable module name for the target.

## Updating The Full Environment

`environment/all` controls what `./setup.sh` and `./setup.sh all` configure.

Add a module there only when the application is part of the complete current environment.

Do not add optional, experimental, heavyweight, machine-specific, account-specific, or rarely used tools to `environment/all` unless the user explicitly wants them in the default full setup.

If the user's wording implies they want the application as part of their normal environment, adding it to `environment/all` is reasonable. If the wording only asks to create support for the application, leave it opt-in or ask one short clarification question.

Example:

```text
wayland
hypr
hyprlock
kitty
rofi
waybar
nvim
mako
```

## Naming Rules

- Use lowercase hyphen-separated module names when possible.
- Match the module directory name, setup target, and package file path.
- Keep aliases only when they preserve existing user-facing behavior, such as `lock` mapping to `hyprlock`.
- Avoid introducing a new alias unless the user asks for it.

## README Updates

When adding a user-facing module, update `README.md`:

- Add the target under the setup command list if users should call it directly.
- Add a short target description.
- Update the environment tree if the documented module list changes.
- Avoid describing the workflow as package installation first. Prefer language like "configures", "prepares", or "sets up".

Keep README text concise and user-facing. Document how to run the target and what it configures; do not duplicate the entire implementation.

If `environment/all` changes, update any README section that describes the complete environment or module tree.

## Verification

After adding or changing a module, run:

```bash
bash -n setup.sh lib/*.sh environment/modules/*/setup.sh
./setup.sh <module> --dry-run
./setup.sh all --dry-run
```

If the module includes shell scripts under `config/<name>/scripts/`, also run:

```bash
bash -n config/<name>/scripts/*.sh
```

For README-only module documentation changes, at minimum check that documented targets match files under `environment/modules/`.

## Common Mistakes To Avoid

- Do not recreate `packages/arch.txt`.
- Do not add package-only commands as the main user flow.
- Do not put every package in `environment/base/packages.arch`.
- Do not put Wayland-specific packages in `base`.
- Do not make one module install another module's package list manually.
- Do not copy configs directly from `setup.sh`.
- Do not skip `--dry-run` handling for destructive operations.
- Do not delete or change unrelated modules while adding a new one.

## Minimal Checklist

Before finishing a module change, confirm:

- `environment/modules/<name>/packages.arch` exists.
- `environment/modules/<name>/setup.sh` exists.
- `setup_module` is defined in the module setup file.
- Required shared layer changes are in `base`, `wayland`, or `module_needs_wayland` as appropriate.
- `environment/all` is updated only if the module belongs to the full setup.
- `README.md` reflects the new user-facing target when needed.
- Syntax and dry-run verification pass.

If this skill is changed, tell the user to restart OpenCode so the running session can reload project skills.
