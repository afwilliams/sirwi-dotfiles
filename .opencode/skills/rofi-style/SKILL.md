---
name: rofi-style
description: Use when editing Rofi config, Rasi themes, launcher scripts, applets, command runner, or files under config/rofi in sirwi-dotfiles.
---

# Rofi Style

Use this skill for any change to the Rofi setup in `sirwi-dotfiles`.

## Scope

Relevant files:

- `config/rofi/config.rasi`
- `config/rofi/themes/sirwi.rasi`
- `config/rofi/themes/sirwi-system.rasi`
- `config/rofi/themes/sirwi-command.rasi`
- `config/rofi/themes/sirwi-applet.rasi`
- `config/rofi/scripts/*.sh`
- `config/hypr/config/rules.lua` when changing Rofi blur/layer behavior

## Visual Language

Preserve the Sirwi glass style:

```rasi
background: rgba(10, 15, 30, 0%);
surface: rgba(31, 58, 92, 72%);
surface-soft: rgba(36, 66, 102, 78%);
surface-hover: rgba(41, 75, 115, 88%);
accent: rgba(245, 211, 137, 94%);
border: #0a0f1e;
text: #f8fafc;
muted: rgba(232, 236, 245, 72%);
selected-text: #1a1d28;
```

Typography:

- Use `JetBrainsMono Nerd Font`.
- Keep normal text around `13` or `14`.
- Use bold only for prompts, labels, or strong accents.

## Shared Theme Rules

- Use `transparency: "real"` on Rofi windows.
- Use transparent outer `window` background.
- Use `@surface` for the main glass panel.
- Use a dark border: `3px`, `@border`, radius `18px` on `mainbox`.
- Use `@surface-soft` for item cards.
- Use `@accent` with `#1a1d28` text for selected items.
- Prefer rounded cards with `border-radius: 12px`.
- Prefer dark pill input bars with radius `999px`.
- Avoid introducing unrelated colors unless the design intentionally changes.

## Launcher Rules

The main launcher is `config/rofi/themes/sirwi.rasi`.

Current behavior:

- `SUPER + SPACE` opens Rofi with native modes: `Apps`, `Files`, `Commands`.
- The mode switcher appears below the input.
- Results are a single vertical column, not a grid.
- Items are horizontal cards with icon on the left and text on the right.

Preserve these patterns unless the user explicitly asks otherwise:

```rasi
mainbox {
  children: [ inputbar, mode-switcher, listview ];
}

listview {
  columns: 1;
  flow: vertical;
}

element {
  orientation: horizontal;
  background-color: @surface-soft;
  border-color: @border;
}
```

## Applet Rules

Applet themes include `sirwi-system.rasi` and `sirwi-applet.rasi`.

- Applets should be compact vertical menus.
- Hide input unless the applet needs typing.
- Use horizontal cards with text aligned left.
- Use selected state with gold accent background and dark selected text.
- Be careful with real system actions such as shutdown, reboot, suspend, lock, and Hyprland exit.

## Command Runner Rules

The command runner uses `config/rofi/themes/sirwi-command.rasi` and `config/rofi/scripts/command.sh`.

- Keep it input-only.
- Do not show a listview.
- Keep placeholder text short and clear.
- Execute commands in the background without leaving a terminal open.
- Preserve shell-command behavior unless the user explicitly asks for safer confirmation.

## Hyprland Blur Rule

Rofi is a layer surface, so blur must use `hl.layer_rule`, not `hl.window_rule`.

Expected rule:

```lua
hl.layer_rule({
    name  = "rofi-liquid-glass",
    match = { namespace = "^rofi$" },

    blur         = true,
    ignore_alpha = 0.2,
})
```

Do not add unsupported window fields like `blur` or `ignore_alpha` to `hl.window_rule` for Rofi.

## Script Rules

- Keep scripts in `config/rofi/scripts/` POSIX-friendly Bash where practical.
- Use `#!/usr/bin/env bash`.
- Quote variables and paths.
- Keep user-facing menu labels stable unless the user asks to rename them.
- After adding a script, ensure it is executable in the repo and in installed config.

## Verification

After Rofi changes, run these checks when feasible:

```bash
bash -n config/rofi/scripts/*.sh
rofi -dump-config >/dev/null
```

If Hyprland rules are changed, run:

```bash
hyprctl reload
```

If the skill itself is changed, tell the user to restart OpenCode so it can reload project skills.
