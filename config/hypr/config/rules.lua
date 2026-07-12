hl.window_rule({
    name  = "suppress-maximize-events",
    match = { class = ".*" },

    suppress_event = "maximize",
})

hl.window_rule({
    name  = "fix-xwayland-drags",
    match = {
        class      = "^$",
        title      = "^$",
        xwayland   = true,
        float      = true,
        fullscreen = false,
        pin        = false,
    },

    no_focus = true,
})

-- Liquid Glass para Waybar
-- Waybar es una layer surface, no una ventana normal.
hl.layer_rule({
    name  = "waybar-liquid-glass",
    match = { namespace = "^waybar$" },

    blur         = true,
    ignore_alpha = 0.2,
})

hl.layer_rule({
    name  = "rofi-liquid-glass",
    match = { namespace = "^rofi$" },

    blur         = true,
    ignore_alpha = 0.2,
})

hl.layer_rule({
    name  = "swaync-notification-liquid-glass",
    match = { namespace = "^swaync-notification-window$" },

    blur         = true,
    ignore_alpha = 0.2,
})

hl.layer_rule({
    name  = "swaync-control-center-liquid-glass",
    match = { namespace = "^swaync-control-center$" },

    blur         = true,
    ignore_alpha = 0.2,
})

hl.workspace_rule({
    workspace = "special:magic",
    on_created_empty = [[kitty --class magic-dashboard --title Magic sh -lc 'if command -v fastfetch >/dev/null 2>&1; then fastfetch; else printf "fastfetch is not installed yet. Run ./setup.sh hypr when sudo is available.\n"; fi; exec "${SHELL:-/bin/bash}"']],
})

hl.window_rule({
    name  = "move-hyprland-run",
    match = { class = "hyprland-run" },

    move  = "20 monitor_h-120",
    float = true,
})

hl.window_rule({
    name  = "bluetooth-tui-modal",
    match = { class = "^bluetooth-tui$" },

    float = true,
    size  = "720 520",
    pin   = true,
})

hl.window_rule({
    name  = "wifi-tui-modal",
    match = { class = "^wifi-tui$" },

    float = true,
    size  = "720 520",
    pin   = true,
})

hl.window_rule({
    name  = "audio-control-modal",
    match = { class = "^org\\.pulseaudio\\.pavucontrol$" },

    float  = true,
    center = true,
    pin    = true,
})
