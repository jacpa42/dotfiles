-- source /usr/share/hypr/stubs/hl.meta.lua

local util = require("util")

local env = {
	DEFAULT_WALLPAPER = os.getenv("DEFAULT_WALLPAPER") or "",
	HYPRCURSOR_SIZE = 24,
	HYPRCURSOR_THEME = "catppuccin-mocha-mauve-cursors",
	QT_QPA_PLATFORMTHEME = "qt6ct",
	CHAT_WORKSPACE = util.envint("CHAT_WORKSPACE", 0),
	WEB_WORKSPACE = util.envint("WEB_WORKSPACE", 1),
	TERMINAL_WORKSPACE = util.envint("TERMINAL_WORKSPACE", 2),
	STEAM_WORKSPACE = util.envint("STEAM_WORKSPACE", 3),
	ANKI_WAYLAND = 1,
	AQ_DRM_DEVICES = "/dev/dri/card2:/dev/dri/card1",
	CLUTTER_BACKEND = "wayland",
	GDK_BACKEND = "wayland,x11,*",
	GTK_THEME = "oomox-black-metal-khold",
	QT_AUTO_SCREEN_SCALE_FACTOR = "1",
	QT_QPA_PLATFORM = "wayland;xcb",
	QT_WAYLAND_DISABLE_WINDOWDECORATION = 1,
	RADV_PERFTEST = "video_decode,video_encode",
	SDL_VIDEODRIVER = "wayland",
	XCURSOR_SIZE = 24,
	XCURSOR_THEME = "catppuccin-mocha-mauve-cursors",
	XDG_CURRENT_DESKTOP = "Hyprland",
	XDG_SESSION_DESKTOP = "Hyprland",
	XDG_SESSION_TYPE = "wayland",
}
for key, value in pairs(env) do
	hl.env(key, value)
end

hl.on("hyprland.start", function()
	hl.exec_cmd("waybar")
	hl.exec_cmd("foot --server")
	hl.exec_cmd("mpd")
	hl.exec_cmd("fcitx5 -d")
	hl.exec_cmd('hyprctl setcursor "' .. env.HYPRCURSOR_THEME .. '" "' .. env.HYPRCURSOR_SIZE .. '"')
	hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
	hl.exec_cmd("dbus-update-activation-environment --systemd QT_QPA_PLATFORMTHEME=" .. env.QT_QPA_PLATFORMTHEME)
	hl.exec_cmd("gsettings set org.gnome.desktop.interface cursor-theme " .. env.HYPRCURSOR_THEME)
	hl.exec_cmd("jacob_hyprwall --force --set-last")
	hl.exec_cmd("hyprcapture -r 50 '" .. os.getenv("HOME") .. "/Projects/forfun/hyprcapture/hyprcapture.sqlite'")
end)

hl.monitor({
	output = "DP-1",
	mode = "2560x1440@240",
	position = "0x0",
	transform = 0,
})
hl.monitor({
	output = "DP-5",
	mode = "3840x2160@30",
	position = "-3840x0",
	transform = 0,
})
hl.monitor({
	output = "HDMI-A-1",
	mode = "3840x2160@60",
	position = "-3840x0",
	transform = 0,
})
hl.monitor({
	output = "eDP-1",
	mode = "2560x1440@165",
	position = "0x0",
	transform = 0,
})
hl.monitor({
	output = "eDP-2",
	mode = "2560x1600@165",
	position = "0x0",
	transform = 0,
})

hl.config({
	general = {
		gaps_in = 1,
		gaps_out = 0,
		border_size = 0,
		col = {
			active_border = "rgba(974b46ff)",
			inactive_border = "rgba(8e8e8eff)",
		},
		resize_on_border = false,
		allow_tearing = true,
		layout = "scrolling",
	},

	decoration = {
		rounding = 0,
		inactive_opacity = 0.8,
		fullscreen_opacity = 1,
		shadow = { enabled = false },
		blur = { enabled = false },
	},

	animations = { enabled = false },

	misc = {
		disable_hyprland_logo = true,
		disable_splash_rendering = true,
		font_family = "JetBrainsMono Nerd Font",
		splash_font_family = "JetBrainsMono Nerd Font",
		force_default_wallpaper = 0,
		vrr = 0,
		disable_autoreload = true,
		on_focus_under_fullscreen = 1,
		enable_anr_dialog = false,
	},

	debug = { vfr = true },

	cursor = {
		hide_on_key_press = true,
		inactive_timeout = 0.5,
		warp_on_change_workspace = 0,
		zoom_factor = 1,
	},

	ecosystem = {
		enforce_permissions = false,
		no_update_news = false,
		no_donation_nag = false,
	},

	input = {
		follow_mouse = 1,
		focus_on_close = 2,
		repeat_rate = 60,
		repeat_delay = 200,
	},

	scrolling = {
		fullscreen_on_one_column = true,
		column_width = 0.98,
		follow_min_visible = 0.4,
		explicit_column_widths = "0.5,0.98",
		focus_fit_method = 1,
		follow_focus = true,
		direction = "right",
	},
})

hl.device({
	name = "razer-razer-blade-keyboard",
	kb_layout = "gb",
	kb_options = "caps:escape",
})
hl.device({
	name = "framework-laptop-16-keyboard-module---ansi-keyboard",
	kb_options = "caps:escape",
})
hl.gesture({ fingers = 2, direction = "pinch", action = "cursorZoom", zoom_level = 1, mode = "live" })

local terminal_popup_app_classes = {
	"tpopup",
	"rmpc",
	"yazi",
	"termfilechooser",
	"btop",
	"lazygit",
	"wiremix",
	"bluetoothctl",
	"iwctl",
}
local terminal_popup_regex = "^(" .. table.concat(terminal_popup_app_classes, "|") .. ")$"

hl.window_rule({
	name = "window can grab the entire screen on start-up and tile",
	match = { class = ".*" },
	suppress_event = "maximize",
	decorate = false,
	tile = true,
})
hl.window_rule({
	name = "Spotify rules",
	match = { class = "(?i)spotify" },
	workspace = env.CHAT_WORKSPACE,
	opacity = 0.9,
})
hl.window_rule({
	name = "Tiled map editor rules",
	match = { class = "org.mapeditor.tiled" },
	workspace = env.TERMINAL_WORKSPACE,
})
hl.window_rule({
	name = "Qelectrotech rules",
	match = { class = "(?i).*qelectrotech" },
	workspace = env.WEB_WORKSPACE,
})
hl.window_rule({
	name = "Aseprite rules",
	match = { class = "Aseprite" },
	workspace = env.TERMINAL_WORKSPACE,
	tile = true,
})
hl.window_rule({
	name = "Discord rules",
	match = { class = "(Discord|WebCord|vesktop)" },
	workspace = env.CHAT_WORKSPACE,
	tile = true,
})
hl.window_rule({
	name = "Rules for steam games",
	match = { class = ".*steam_app.*" },
	workspace = env.STEAM_WORKSPACE,
})
hl.window_rule({
	name = "Steam popup window rules",
	match = { class = "steam" },
	workspace = env.STEAM_WORKSPACE,
	opacity = 0.9,
	float = true,
})
hl.window_rule({
	name = "Main steam window rules",
	match = { title = "^(Steam)" },
	workspace = env.STEAM_WORKSPACE,
	tile = true,
})
hl.window_rule({
	name = "browser rules",
	match = { class = "(firefox|org.qutebrowser.qutebrowser|librewolf)" },
	workspace = env.WEB_WORKSPACE,
	opacity = 1.0,
})
hl.window_rule({
	name = "Neovim rules",
	match = { class = "nvim.*" },
	workspace = env.TERMINAL_WORKSPACE,
	tile = true,
})
hl.window_rule({
	name = "Foot rules",
	match = { class = "(foot|footclient)" },
	workspace = env.TERMINAL_WORKSPACE,
	tile = true,
})
hl.window_rule({
	name = "fixes davinci popup jank",
	match = { class = "^(resolve)" },
	float = true,
	workspace = env.CHAT_WORKSPACE,
})
hl.window_rule({
	name = "tile the main davinci window",
	match = { title = ".*DaVinci Resolve Studio.*" },
	tile = true,
	workspace = env.CHAT_WORKSPACE,
})
hl.window_rule({
	name = "inkscape rules",
	match = { class = "org.inkscape.Inkscape" },
	workspace = env.CHAT_WORKSPACE,
})
hl.window_rule({
	name = "mordith is on steam workspace",
	match = { class = "mordith" },
	workspace = env.TERMINAL_WORKSPACE,
})
hl.window_rule({
	name = "Tricky towers fullscreen",
	match = { title = "Tricky Towers" },
	workspace = env.STEAM_WORKSPACE,
	fullscreen = true,
})
hl.window_rule({
	name = "small popup window rules",
	match = { class = "(hyprland-share-picker)" },
	border_size = 0,
	center = 1,
	float = true,
	no_anim = true,
	pin = true,
	size = { "(monitor_w*0.6)", "(monitor_h*0.6)" },
	stay_focused = true,
})
hl.window_rule({
	name = "Terminal app rules",
	match = { class = terminal_popup_regex },
	border_size = 0,
	center = 1,
	float = true,
	no_anim = true,
	pin = true,
	size = { "(monitor_w*0.9)", "(monitor_h*0.9)" },
	stay_focused = true,
})
hl.window_rule({
	name = "anki rules",
	match = { class = "anki" },
	tile = true,
	workspace = env.WEB_WORKSPACE,
})
hl.window_rule({
	name = "pinentry stuff",
	match = { class = "Pinentry.*" },
	pin = true,
	float = true,
	center = true,
	stay_focused = true,
	no_screen_share = true,
})
hl.window_rule({
	name = "ueberzugg must float",
	match = { class = "ueberzugpp.*" },
	float = true,
	no_initial_focus = true,
})

local mod = "SUPER"
hl.bind(mod .. "+J", hl.dsp.layout("colresize +conf"))
hl.bind(mod .. "+K", hl.dsp.layout("colresize -conf"))
hl.bind(mod .. "+R", hl.dsp.layout("focus right"))
hl.bind(mod .. "+E", hl.dsp.layout("focus left"))
hl.bind(mod .. "+ALT+R", hl.dsp.layout("swapcol r"))
hl.bind(mod .. "+ALT+E", hl.dsp.layout("swapcol l"))
hl.bind(mod .. "+T", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mod .. "+W", hl.dsp.window.close({}))
hl.bind(mod .. "+RETURN", hl.dsp.window.fullscreen({ action = "toggle" }))
hl.bind(mod .. "+SPACE", hl.dsp.exec_cmd("pkill fuzzel || fuzzel"))
hl.bind(mod .. "+BACKSPACE", hl.dsp.exec_raw("footclient"))
hl.bind(mod .. "+P", hl.dsp.exec_raw("jacob_passwords --type"))
hl.bind(mod .. "+U", hl.dsp.exec_raw("jacob_sessionizer gitweb"))
hl.bind(mod .. "+PERIOD", hl.dsp.exec_raw("jacob_sessionizer projects"))
hl.bind(mod .. "+C", hl.dsp.exec_raw("jacob_color_picker"))
hl.bind(mod .. "+X", hl.dsp.exec_raw("jacob_screenshot"))
hl.bind(mod .. "+H", hl.dsp.exec_raw("jacob_search_history"))
hl.bind(mod .. "+V", hl.dsp.exec_cmd("jacob_hyprwall"), { repeating = true })
hl.bind(mod .. "+SHIFT+V", hl.dsp.exec_cmd("jacob_hyprwall -r"), { repeating = true })
hl.bind(mod .. "+ALT+V", hl.dsp.exec_cmd("jacob_hyprwall -s " .. env.DEFAULT_WALLPAPER))
hl.bind(mod .. "+CTRL+V", hl.dsp.exec_cmd("jacob_hyprwall -R"), { repeating = true })
hl.bind(mod .. "+ALT+SPACE", hl.dsp.exec_raw("jacob_fuzzy_focus_window"))

local terminal_apps = {
	lazygit = { key = mod .. "+L", cmd = "jacob_sessionizer lazygit" },
	btop = { key = mod .. "+B", cmd = "footclient -ET btop -a tpopup btop" },
	rmpc = { key = mod .. "+M", cmd = "footclient -ET rmpc -a tpopup rmpc" },
	yazi = { key = mod .. "+Y", cmd = "footclient -ET yazi -a tpopup yazi" },
}
for app, config in pairs(terminal_apps) do
	hl.bind(config.key, function()
		local matching = util.close_non_matching(app, terminal_popup_app_classes)
		if matching == 0 then
			hl.exec_cmd(config.cmd)
		else
			hl.dispatch(hl.dsp.window.close({ class = terminal_popup_regex }))
		end
	end)
end

local workspace_config = {
	S = env.CHAT_WORKSPACE,
	D = env.WEB_WORKSPACE,
	F = env.TERMINAL_WORKSPACE,
	G = env.STEAM_WORKSPACE,
}
for key, value in pairs(workspace_config) do
	hl.bind(mod .. "+" .. key, hl.dsp.focus({ workspace = value }))
	hl.bind(mod .. "+ALT+" .. key, hl.dsp.window.move({ workspace = value, follow = true }))
end

for i = 1, 9, 1 do
	hl.bind(mod .. "+" .. i, hl.dsp.focus({ workspace = i }))
	hl.bind(mod .. "+ALT+" .. i, hl.dsp.window.move({ workspace = i, follow = true }))
end

local l = { locked = true }
local rl = { repeating = true, locked = true }

hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_raw("wpctl set-volume -l 1.0 @DEFAULT_AUDIO_SINK@ 1%+"), rl)
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_raw("wpctl set-volume -l 1.0 @DEFAULT_AUDIO_SINK@ 1%-"), rl)
hl.bind("XF86AudioMute", hl.dsp.exec_raw("wpctl set-mute @DEFAULT_SINK@ toggle"), l)
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_raw("brightnessctl set 5%-"), rl)
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_raw("brightnessctl set +5%"), rl)
hl.bind("Print", hl.dsp.exec_raw("jacob_screenshot --output"), l)
hl.bind("XF86Tools", hl.dsp.exec_raw("pkill fuzzel || fuzzel"), l)
hl.bind("XF86AudioPlay", hl.dsp.exec_raw("rmpc togglepause"), l)
hl.bind("XF86AudioPrev", hl.dsp.exec_raw("rmpc prev"), l)
hl.bind("XF86AudioNext", hl.dsp.exec_raw("rmpc next"), l)

hl.bind(mod .. "+mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mod .. "+mouse:273", hl.dsp.window.resize(), { mouse = true })
