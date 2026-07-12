---
name: waybar-style
description: Use when editing Waybar, Hyprpaper wallpaper, Hyprland Waybar blur rules, battery/network/Bluetooth modules, or files under config/waybar and related Hyprland visual assets in sirwi-dotfiles.
---

# Waybar Style

Use this skill for changes to the Sirwi Waybar setup, Hyprpaper wallpaper integration, and related Hyprland visual behavior.

## Scope

Relevant files:

- `config/waybar/config`
- `config/waybar/style.css`
- `config/waybar/scripts/bluetooth-status.sh`
- `config/waybar/sir-williams-avatar.png`
- `config/hypr/hyprpaper.conf`
- `config/hypr/assets/wallpapers/sirwi-room.png`
- `config/hypr/config/rules.lua` when changing Waybar blur/layer behavior

Installed runtime paths usually map to:

- `~/.config/waybar/config`
- `~/.config/waybar/style.css`
- `~/.config/waybar/scripts/bluetooth-status.sh`
- `~/.config/hypr/hyprpaper.conf`
- `~/.config/hypr/assets/wallpapers/sirwi-room.png`

## Visual Language

Preserve the Sirwi gentleman liquid-glass style:

```css
surface: rgba(31, 58, 92, 0.72);
surface-hover: rgba(41, 75, 115, 0.82);
surface-hover-workspace: rgba(36, 66, 102, 0.86);
accent: rgba(245, 211, 137, 0.92);
border: #0a0f1e;
text: #f8fafc;
muted: rgba(232, 236, 245, 0.78);
critical: rgba(127, 29, 29, 0.82);
charging: #86efac;
warning: #fde68a;
```

The mood should feel like a refined private mansion lounge: deep gentleman navy, dark borders, champagne-gold accents, subtle glass reflections, and calm luxury. Avoid unrelated bright colors unless they represent state, such as battery warning or critical.

## Typography

- Use `JetBrainsMono Nerd Font`, with `Font Awesome 6 Free` and `sans-serif` fallbacks.
- Keep the base font size at `13px`.
- Use bold sparingly, mainly for the launcher/date group.
- Nerd Font icons are expected; do not replace them with emoji.

## Bar Geometry

- Keep Waybar height at `36`.
- Keep `window#waybar` transparent.
- Keep the outer Waybar box margin close to `6px 10px 0 10px`.
- Keep global Waybar config spacing at `0`.
- Use CSS margins to control gaps. Do not rely on Waybar's global `spacing` for grouped modules.

Expected config:

```json
"height": 36,
"spacing": 0
```

## Layout

Current module layout:

```json
"modules-left": [
  "custom/launcher",
  "clock#date"
],
"modules-center": [
  "hyprland/workspaces"
],
"modules-right": [
  "cpu",
  "memory",
  "pulseaudio",
  "custom/bluetooth",
  "network",
  "battery",
  "tray"
]
```

Preserve this layout unless the user explicitly asks to reorganize the bar.

## Grouping Pattern

Grouped modules should look like one continuous capsule with floating internal separators.

Use this separator pattern:

```css
background:
  linear-gradient(
    to bottom,
    transparent 24%,
    #0a0f1e 24%,
    #0a0f1e 76%,
    transparent 76%
  ) left center / 1px 100% no-repeat,
  rgba(31, 58, 92, 0.72);
```

Rules:

- Do not use full-height real vertical borders between grouped modules.
- Use a `1px` floating separator drawn with a `linear-gradient`.
- First item owns the left border and left rounded corners.
- Middle items have no rounded corners and no left/right border.
- Last item owns the right border and right rounded corners.
- Keep group segment borders at `2px solid #0a0f1e`.

## Left Group

The left group is `custom/launcher + clock#date`.

Preserve:

- Launcher text: `{{Sir. Williams}}`
- Launcher avatar background image: `sir-williams-avatar.png`
- Launcher opens Rofi with `rofi -show drun`.
- Date format: `{:%A %d de %B  %H:%M}`.
- Launcher is the left segment with left rounded corners.
- Date is the right segment with the floating separator on its left.

In the repo CSS, keep avatar paths relative where possible:

```css
background-image: url("sir-williams-avatar.png");
```

Installed configs may use absolute paths only when required by the target environment.

## Workspaces

Workspaces are the visual reference for internal separators.

Preserve:

- `hyprland/workspaces` centered.
- `format`: `{name}{windows}`.
- `format-window-separator`: empty string.
- Active workspace uses champagne gold: `rgba(245, 211, 137, 0.92)`.
- Inactive workspaces use gentleman blue: `rgba(31, 58, 92, 0.72)`.
- Hover should not cause text/icon animation or unwanted color shifts.

Important hover stabilization:

```css
#workspaces button,
#workspaces button label {
  transition: none;
  animation: none;
}

#workspaces button:hover label {
  color: inherit;
  text-shadow: none;
  background: transparent;
}
```

## Right Modules

Standalone modules:

- `cpu`
- `memory`
- `pulseaudio`
- `tray`

These use rounded capsules, deep blue surface, dark border, and soft shadow. Current standalone border thickness is `3px`; do not change it unless unifying the whole right side intentionally.

Grouped right-side modules:

```text
[ Bluetooth | WiFi | Battery ]  [ Tray ]
```

Preserve this group:

- `custom/bluetooth` is the first segment.
- `network` is the middle segment.
- `battery` is the final segment.
- `tray` remains separate after the group.

## Bluetooth

Bluetooth is a custom JSON module backed by:

```text
config/waybar/scripts/bluetooth-status.sh
```

Expected behavior:

- Powered on: `󰂱`, class `on`, green text.
- Powered off: `󰂲`, class `off`, normal text.
- Unknown: `󰂯`, class `unknown`, soft red text.

Expected config shape:

```json
"custom/bluetooth": {
  "exec": "~/.config/waybar/scripts/bluetooth-status.sh",
  "interval": 1,
  "return-type": "json",
  "tooltip": false,
  "on-click": "rfkill unblock bluetooth && kitty --class bluetooth-tui --title Bluetooth -e bluetui"
}
```

## Network

Network is the middle segment of the Bluetooth/WiFi/Battery group.

Preserve:

- WiFi format: `󰖩  {essid}`.
- Ethernet format: `󰈀  ethernet`.
- Disconnected format: `󰤮  sin red`.
- Click opens `nmtui` in Kitty after unblocking WiFi.
- Left floating separator is drawn with the shared `linear-gradient` pattern.
- No left or right border in the grouped middle state.

## Battery

Battery is the final segment of the Bluetooth/WiFi/Battery group.

Expected device binding:

```json
"bat": "BAT1",
"adapter": "ACAD"
```

These are intentional because the system may expose other batteries, such as HID devices or keyboards. Keep Waybar pinned to the internal laptop battery unless the hardware changes.

Expected state thresholds:

```json
"states": {
  "warning": 30,
  "critical": 15
}
```

Visible battery text should be icon-only:

```json
"format": "{icon}",
"format-charging": "{icon}",
"format-plugged": "󰁹",
"format-full": "󰁹"
```

Keep battery tooltips in English:

```json
"tooltip-format": "Battery: {capacity}%\nStatus: battery\nTime: {timeTo}",
"tooltip-format-discharging": "Battery: {capacity}%\nStatus: unplugged\nTime remaining: {timeTo}",
"tooltip-format-charging": "Battery: {capacity}%\nStatus: plugged in, charging\nTime to full: {timeTo}",
"tooltip-format-plugged": "Battery: {capacity}%\nStatus: plugged in\nTime: {timeTo}",
"tooltip-format-full": "Battery: {capacity}%\nStatus: fully charged"
```

Do not use `{status}` in battery tooltip formats. Waybar's battery module does not support `{status}` and logs `battery: argument not found`.

Use this icon progression from low to high:

```json
"format-icons": [
  "󰁺",
  "󰁻",
  "󰁼",
  "󰁽",
  "󰁾",
  "󰁿",
  "󰂀",
  "󰂁",
  "󰂂",
  "󰁹"
]
```

Critical battery behavior:

- `#battery.warning` is yellow text only.
- `#battery.critical` uses a red background and a subtle pulse animation.
- The critical pulse stops when `#battery.charging` or `#battery.plugged` is active.
- Keep the floating separator in the critical and hover backgrounds.

## Wallpaper

Hyprpaper wallpaper belongs with Hyprland visual assets, not in `Pictures`.

Repo path:

```text
config/hypr/assets/wallpapers/sirwi-room.png
```

Installed path:

```text
~/.config/hypr/assets/wallpapers/sirwi-room.png
```

Expected `config/hypr/hyprpaper.conf`:

```conf
wallpaper {
    monitor = eDP-1
    path = ~/.config/hypr/assets/wallpapers/sirwi-room.png
    fit_mode = cover
}

wallpaper {
    monitor =
    path = ~/.config/hypr/assets/wallpapers/sirwi-room.png
    fit_mode = cover
}

splash = false
ipc = true
```

Keep `splash = false`. Hyprpaper splash text appears as random overlay text on wallpapers and should remain disabled.

Wallpaper visual direction:

- Elegant animated-sitcom-inspired mansion interior.
- No people, no characters, no computers, no modern electronics.
- Deep gentleman navy walls, gold trim, chandelier, staircase, warm lamps, polished marble, dark wood, refined mansion mood.
- Should harmonize with Waybar's `rgba(31, 58, 92, 0.72)` surface color.

## Hyprland Blur Rule

Waybar is a layer surface. Blur must use a layer rule, not a window rule.

Expected rule in `config/hypr/config/rules.lua`:

```lua
hl.layer_rule({
    name  = "waybar-liquid-glass",
    match = { namespace = "^waybar$" },

    blur         = true,
    ignore_alpha = 0.2,
})
```

Do not add unsupported Waybar blur fields to normal window rules.

## Common Pitfalls

- Do not set Waybar global `spacing` back to `2`; it creates transparent gaps between grouped modules.
- Do not replace floating separators with real full-height borders.
- Do not make `network` the last segment while `battery` is grouped; battery owns the right rounded corners.
- Do not show battery percentage in the bar unless explicitly requested; keep it in the tooltip.
- Do not use `{status}` in battery tooltip formats.
- Do not store the active wallpaper under `Pictures/Wallpapers` in this dotfiles design.
- Do not re-enable `splash = true` in Hyprpaper.
- Do not use emoji as module icons; use Nerd Font glyphs.

## Verification

After Waybar changes, run when feasible:

```bash
pkill waybar; waybar >/tmp/waybar.log 2>&1 &
```

Then inspect:

```text
/tmp/waybar.log
```

Expected healthy signs:

- Waybar uses `config/waybar/config` and `config/waybar/style.css` in installed config.
- Bar height remains `36`.
- No `battery: argument not found` errors.

After Hyprpaper changes, run:

```bash
pkill hyprpaper; hyprpaper >/tmp/hyprpaper.log 2>&1 &
```

Then inspect:

```text
/tmp/hyprpaper.log
```

If Hyprland layer rules changed, run:

```bash
hyprctl reload
```

If this skill itself is changed, tell the user to quit and restart OpenCode so project skills are reloaded.
