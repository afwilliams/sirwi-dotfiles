local vars = require("config.variables")

local mainMod = vars.mainMod
local terminal = vars.terminal
local fileManager = vars.fileManager
local menu = vars.menu
local runMenu = vars.runMenu

local function moveWindowOrGroupTab(direction, forward)
    return function()
        local window = hl.get_active_window()
        local group = window and window.group

        if not group or group.size <= 1 then
            hl.dispatch(hl.dsp.window.move({ direction = direction, group_aware = true }))
            return
        end

        local atGroupEdge = (forward and group.current_index >= group.size) or (not forward and group.current_index <= 1)

        if atGroupEdge then
            hl.dispatch(hl.dsp.window.move({ out_of_group = direction }))
            return
        end

        hl.dispatch(hl.dsp.group.move_window({ forward = forward }))
    end
end

-- Main apps
hl.bind(mainMod .. " + Return", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(fileManager))

-- Rofi launcher
hl.bind(mainMod .. " + R", hl.dsp.exec_cmd(menu))
hl.bind(mainMod .. " + SPACE", hl.dsp.exec_cmd(menu))
hl.bind(mainMod .. " + SHIFT + SPACE", hl.dsp.exec_cmd(runMenu))

-- Rofi applets
hl.bind(mainMod .. " + X", hl.dsp.exec_cmd("~/.config/rofi/scripts/system.sh"))

-- Notification center
hl.bind(mainMod .. " + N", hl.dsp.exec_cmd("swaync-client -t -sw"))
hl.bind(mainMod .. " + SHIFT + N", hl.dsp.exec_cmd("swaync-client -d -sw"))

-- Lock screen
hl.bind(mainMod .. " + L", hl.dsp.exec_cmd("hyprlock"))

-- Rofi command runner
hl.bind(mainMod .. " + SHIFT + X", hl.dsp.exec_cmd("~/.config/rofi/scripts/command.sh"))

-- Window actions
hl.bind(mainMod .. " + Q", hl.dsp.window.close())
hl.bind(mainMod .. " + M", hl.dsp.exec_cmd("command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch 'hl.dsp.exit()'"))
hl.bind(mainMod .. " + V", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + P", hl.dsp.window.pseudo())
hl.bind(mainMod .. " + J", hl.dsp.layout("togglesplit"))

-- Window groups / tabbed windows
hl.bind(mainMod .. " + G", hl.dsp.group.toggle())
hl.bind(mainMod .. " + TAB", hl.dsp.group.next())
hl.bind(mainMod .. " + SHIFT + TAB", hl.dsp.group.prev())
hl.bind(mainMod .. " + CTRL + G", hl.dsp.group.lock_active({ action = "toggle" }))

-- Reorder grouped windows, then move out once an edge is reached.
hl.bind(mainMod .. " + CTRL + left",  moveWindowOrGroupTab("left", false))
hl.bind(mainMod .. " + CTRL + right", moveWindowOrGroupTab("right", true))
hl.bind(mainMod .. " + CTRL + up",    moveWindowOrGroupTab("up", false))
hl.bind(mainMod .. " + CTRL + down",  moveWindowOrGroupTab("down", true))

-- Move current window out of group
hl.bind(mainMod .. " + CTRL + SHIFT + G", hl.dsp.window.move({ out_of_group = true }))

-- Move focus with arrows
hl.bind(mainMod .. " + left",  hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + up",    hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + down",  hl.dsp.focus({ direction = "down" }))

-- Workspaces
for i = 1, 10 do
    local key = i % 10
    hl.bind(mainMod .. " + " .. key,         hl.dsp.focus({ workspace = i }))
    hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

-- Special workspace / scratchpad
hl.bind(mainMod .. " + S",         hl.dsp.exec_cmd("$HOME/.config/waybar/scripts/special-workspace.sh toggle"))
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))

-- Scroll through existing workspaces
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up",   hl.dsp.focus({ workspace = "e-1" }))

-- Move/resize windows with mouse
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Screenshots
hl.bind("Print", hl.dsp.exec_cmd('grim -g "$(slurp)" - | tee ~/Pictures/Screenshots/screenshot-$(date +%Y%m%d-%H%M%S).png | wl-copy --type image/png'))

-- Multimedia keys
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),      { locked = true, repeating = true })
hl.bind("XF86AudioMute",        hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),     { locked = true, repeating = true })
hl.bind("XF86AudioMicMute",     hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),   { locked = true, repeating = true })

hl.bind("XF86MonBrightnessUp",   hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"), { locked = true, repeating = true })

-- Media player
hl.bind("XF86AudioNext",  hl.dsp.exec_cmd("playerctl next"),       { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay",  hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev",  hl.dsp.exec_cmd("playerctl previous"),   { locked = true })
