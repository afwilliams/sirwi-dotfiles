hl.config({
    general = {
        gaps_in  = 5,
        gaps_out = {
            top    = 10,
            right  = 20,
            bottom = 10,
            left   = 20,
        },

        border_size = 3,

        col = {
            active_border   = { colors = {"rgba(f5d389ee)", "rgba(1f3a5cee)"}, angle = 45 },
            inactive_border = "rgba(0a0f1eaa)",
        },

        resize_on_border = false,
        allow_tearing = false,
        layout = "dwindle",
    },

    decoration = {
        rounding       = 12,
        rounding_power = 2,

        dim_special = 0.30,

        active_opacity   = 1.0,
        inactive_opacity = 1.0,

        shadow = {
            enabled      = true,
            range        = 4,
            render_power = 3,
            color        = 0xee1a1a1a,
        },

        blur = {
            enabled   = true,
            size      = 3,
            passes    = 1,
            vibrancy  = 0.1696,
            special   = true,
        },
    },

    group = {
        col = {
            border_active          = { colors = {"rgba(f5d389ff)", "rgba(c4b5fdff)", "rgba(1f3a5cff)"}, angle = 45 },
            border_inactive        = "rgba(1f3a5cbb)",
            border_locked_active   = { colors = {"rgba(fca5a5ff)", "rgba(f5d389ff)"}, angle = 45 },
            border_locked_inactive = "rgba(3b2430cc)",
        },

        groupbar = {
            enabled       = true,
            render_titles = true,
            gradients     = true,
            height        = 28,
            font_size     = 12,
            font_family   = "JetBrainsMono Nerd Font",
            font_weight_active = "700",
            font_weight_inactive = "500",
            text_color    = "rgba(f8fafcff)",
            text_color_inactive = "rgba(f8fafcff)",
            rounding      = 14,
            rounding_power = 2,
            gradient_rounding = 14,
            gradient_rounding_power = 2,
            round_only_edges = false,
            gradient_round_only_edges = false,
            indicator_height = 1,
            indicator_gap    = 0,
            gaps_out         = 4,

            col = {
                active          = { colors = {"rgba(1f3a5cff)", "rgba(1f3a5cff)"}, angle = 0 },
                inactive        = { colors = {"rgba(0a0f1eff)", "rgba(0a0f1eff)"}, angle = 0 },
                locked_active   = { colors = {"rgba(3b2430ff)", "rgba(3b2430ff)"}, angle = 0 },
                locked_inactive = { colors = {"rgba(0a0f1eff)", "rgba(0a0f1eff)"}, angle = 0 },
            },
        },
    },

    animations = {
        enabled = true,
    },
})

hl.curve("easeOutQuint",   { type = "bezier", points = { {0.23, 1},    {0.32, 1}    } })
hl.curve("easeInOutCubic", { type = "bezier", points = { {0.65, 0.05}, {0.36, 1}    } })
hl.curve("linear",         { type = "bezier", points = { {0, 0},       {1, 1}       } })
hl.curve("almostLinear",   { type = "bezier", points = { {0.5, 0.5},   {0.75, 1}    } })
hl.curve("quick",          { type = "bezier", points = { {0.15, 0},    {0.1, 1}     } })

hl.curve("easy", { type = "spring", mass = 1, stiffness = 71.2633, dampening = 15.8273644 })

hl.animation({ leaf = "global",        enabled = true,  speed = 10,   bezier = "default" })
hl.animation({ leaf = "border",        enabled = true,  speed = 5.39, bezier = "easeOutQuint" })
hl.animation({ leaf = "windows",       enabled = true,  speed = 4.79, spring = "easy" })
hl.animation({ leaf = "windowsIn",     enabled = true,  speed = 4.1,  spring = "easy",         style = "popin 87%" })
hl.animation({ leaf = "windowsOut",    enabled = true,  speed = 1.49, bezier = "linear",       style = "popin 87%" })
hl.animation({ leaf = "fadeIn",        enabled = true,  speed = 1.73, bezier = "almostLinear" })
hl.animation({ leaf = "fadeOut",       enabled = true,  speed = 1.46, bezier = "almostLinear" })
hl.animation({ leaf = "fade",          enabled = true,  speed = 3.03, bezier = "quick" })
hl.animation({ leaf = "layers",        enabled = true,  speed = 3.81, bezier = "easeOutQuint" })
hl.animation({ leaf = "layersIn",      enabled = true,  speed = 4,    bezier = "easeOutQuint", style = "fade" })
hl.animation({ leaf = "layersOut",     enabled = true,  speed = 1.5,  bezier = "linear",       style = "fade" })
hl.animation({ leaf = "fadeLayersIn",  enabled = true,  speed = 1.79, bezier = "almostLinear" })
hl.animation({ leaf = "fadeLayersOut", enabled = true,  speed = 1.39, bezier = "almostLinear" })
hl.animation({ leaf = "workspaces",    enabled = true,  speed = 1.94, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "workspacesIn",  enabled = true,  speed = 1.21, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "workspacesOut", enabled = true,  speed = 1.94, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "zoomFactor",    enabled = true,  speed = 7,    bezier = "quick" })

hl.config({
    misc = {
        force_default_wallpaper = 0,
        disable_hyprland_logo   = true,
    },
})
