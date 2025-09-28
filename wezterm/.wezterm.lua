local wezterm = require("wezterm")
local act = wezterm.action
-- local workspace_switcher = wezterm.plugin.require("https://github.com/MLFlexer/smart_workspace_switcher.wezterm")
local config = {
	harfbuzz_features = { "calt=0", "clig=0", "liga=0" },
	font = wezterm.font("JetBrains Mono"), -- Set your favorite font
	color_scheme = "Dracula", -- Use a built-in color scheme
	-- color_scheme = "Tokyo Night", -- Use a built-in color scheme
	colors = {
		cursor_fg = "#111111",
		cursor_bg = "#FF00FF",
	},
	window_background_opacity = 1, -- 0.98, -- Transparency
	font_size = 12.0,
	enable_tab_bar = true,
	use_fancy_tab_bar = false,
	enable_wayland = false, -- decide what makes sense, it doesn't work well in either linux or wsl when true
	tab_bar_at_bottom = false,
	-- window_decorations = "NONE",
	window_decorations = "RESIZE",
	hide_tab_bar_if_only_one_tab = false,
	warn_about_missing_glyphs = false,
	use_resize_increments = false,
	adjust_window_size_when_changing_font_size = false,
	hide_mouse_cursor_when_typing = true,
	inactive_pane_hsb = {
		saturation = 0.9,
		brightness = 0.7,
	},
	-- window_background_image = "/home/xouzoura/Koofr/pictures/wallpapers/californication_hank.jpg",
	window_padding = {
		left = 0,
		right = 0,
		top = 0,
		bottom = 30,
	},

	-- Configure window decorations
	-- enable_auto_margin = false,
	-- adjust_window_size_when_changing_font_size = false, -- Prevent auto-resizing
	-- leader = { key = "Space", mods = "SHIFT" },
	leader = { key = "q", mods = "CTRL" },
	default_prog = { "zsh" }, -- Change this to your preferred shell if necessary
	keys = {
		-- {
		-- 	key = "S",
		-- 	mods = "CTRL",
		-- 	action = workspace_switcher.switch_workspace(),
		-- },
		-- {
		-- 	key = "S",
		-- 	mods = "LEADER",
		-- 	action = workspace_switcher.switch_to_prev_workspace(),
		-- },
		{ key = ".", mods = "ALT", action = wezterm.action.ActivateTabRelative(1) },
		{ key = ",", mods = "ALT", action = wezterm.action.ActivateTabRelative(-1) },
		{ key = "'", mods = "ALT", action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
		-- { key = "_", mods = "ALT", action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }) },
		{ key = "-", mods = "ALT|SHIFT", action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }) },
		-- { key = "h", mods = "ALT|SHIFT", action = wezterm.action.ActivatePaneDirection("Left") },
		-- { key = "l", mods = "ALT|SHIFT", action = wezterm.action.ActivatePaneDirection("Right") },
		-- { key = "k", mods = "ALT|SHIFT", action = wezterm.action.ActivatePaneDirection("Up") },
		-- { key = "j", mods = "ALT|SHIFT", action = wezterm.action.ActivatePaneDirection("Down") },
		-- { key = "o", mods = "ALT|SHIFT", action = wezterm.action.ActivatePaneDirection("Next") },
		{ key = "h", mods = "ALT|CTRL", action = wezterm.action.ActivatePaneDirection("Left") },
		{ key = "l", mods = "ALT|CTRL", action = wezterm.action.ActivatePaneDirection("Right") },
		{ key = "k", mods = "ALT|CTRL", action = wezterm.action.ActivatePaneDirection("Up") },
		{ key = "j", mods = "ALT|CTRL", action = wezterm.action.ActivatePaneDirection("Down") },
		{ key = "o", mods = "ALT|CTRL", action = wezterm.action.ActivatePaneDirection("Next") },
		{ key = ";", mods = "ALT", action = act.SpawnTab("DefaultDomain") },
		{ key = ":", mods = "ALT", action = act.SpawnTab("CurrentPaneDomain") },
		{ key = "[", mods = "ALT", action = act.ActivateCopyMode },
		{
			key = "a",
			mods = "CTRL|SHIFT",
			action = act.ActivateKeyTable({
				name = "resize_pane",
				one_shot = false,
			}),
		},
		{
			-- regex search
			key = "H",
			mods = "SHIFT|CTRL",
			action = wezterm.action.Search({ Regex = "[a-f0-9]{6,}" }),
		},
	},

	key_tables = {
		resize_pane = {
			{ key = "h", action = act.AdjustPaneSize({ "Left", 5 }) },

			{ key = "l", action = act.AdjustPaneSize({ "Right", 5 }) },

			{ key = "k", action = act.AdjustPaneSize({ "Up", 2 }) },

			{ key = "j", action = act.AdjustPaneSize({ "Down", 2 }) },

			{ key = "Escape", action = "PopKeyTable" },
		},
	},
}

-- workspace_switcher.apply_to_config(config)
return config
