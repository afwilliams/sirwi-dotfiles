-- Main Hyprland config
-- Archivo principal: ~/.config/hypr/hyprland.lua

require("config.variables")
require("config.monitors")
pcall(require, "monitors")
pcall(require, "workspaces")
require("config.env")
require("config.permissions")
require("config.appearance")
require("config.layouts")
require("config.input")
require("config.autostart")
require("config.keybinds")
require("config.rules")
