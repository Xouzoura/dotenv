local wezterm = require("wezterm")
local act = wezterm.action

return {
	harfbuzz_features = { "calt=0", "clig=0", "liga=0" },
	font = wezterm.font("JetBrains Mono"), -- Set your favorite font
	color_scheme = "Dracula", -- Use a built-in color scheme
	window_background_opacity = 1, -- 0.98, -- Transparency
	enable_tab_bar = true, -- Show tabs
	use_fancy_tab_bar = false, -- Use minimal tab style
	enable_wayland = true,
	tab_bar_at_bottom = false, -- Ensure the tab bar is at the top
	-- window_decorations = "NONE",
	window_decorations = "RESIZE",
	hide_tab_bar_if_only_one_tab = false,
	warn_about_missing_glyphs = false,
	use_resize_increments = false,
	adjust_window_size_when_changing_font_size = false,
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
	hide_mouse_cursor_when_typing = true,
	keys = {
		-- Close the current tab
		{ key = "Tab", mods = "CTRL", action = "DisableDefaultAssignment" },
		{ key = "Tab", mods = "CTRL|SHIFT", action = "DisableDefaultAssignment" },

		-- Custom tab switching: Leader + Tab to move to the next tab
		{ key = "Tab", mods = "LEADER", action = wezterm.action.ActivateTabRelative(1) },

		-- Switch to specific tabs with Leader + number (1, 2, 3...)
		{ key = "1", mods = "LEADER", action = wezterm.action.ActivateTab(0) },
		{ key = "2", mods = "LEADER", action = wezterm.action.ActivateTab(1) },
		{ key = "3", mods = "LEADER", action = wezterm.action.ActivateTab(2) },
		{
			key = "p",
			mods = "LEADER",
			action = act.PasteFrom("Clipboard"),
		},
		{
			key = "t",
			mods = "LEADER",
			action = wezterm.action.SpawnTab("CurrentPaneDomain"),
		},
		{
			key = "z",
			mods = "LEADER",
			action = act.TogglePaneZoomState,
		},
		{
			key = "w",
			mods = "CMD",
			action = act.CloseCurrentPane({ confirm = true }),
		},
		{
			key = "v",
			mods = "LEADER",
			action = act.ActivateCopyMode,
		},

		-- activate resize mode
		{
			key = "r",
			mods = "LEADER",
			action = act.ActivateKeyTable({
				name = "resize_pane",
				one_shot = false,
			}),
		},

		-- focus panes
		{
			key = "h",
			mods = "LEADER",
			action = act.ActivatePaneDirection("Left"),
		},
		{
			key = "l",
			mods = "LEADER",
			action = act.ActivatePaneDirection("Right"),
		},
		{
			key = "k",
			mods = "LEADER",
			action = act.ActivatePaneDirection("Up"),
		},
		{
			key = "j",
			mods = "LEADER",
			action = act.ActivatePaneDirection("Down"),
		},

		-- add new panes
		{
			key = "-",
			mods = "LEADER",
			action = act.SplitVertical({ domain = "CurrentPaneDomain" }),
		},
		{
			key = "\\",
			mods = "LEADER",
			action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }),
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
