local wezterm = require("wezterm")
local config = wezterm.config_builder()

config.font = wezterm.font("JetBrains Mono")
config.font_size = 13

config.window_decorations = "RESIZE"

config.window_frame = {
	font_size = 13.0,
}

config.window_padding = {
	top = 10,
	bottom = 10,
	left = 10,
	right = 10,
}

config.term = "xterm-256color"
config.enable_tab_bar = false

config.default_prog = { "pwsh" }

config.leader = { key = "b", mods = "CTRL", timeout_milliseconds = 2000 }

config.skip_close_confirmation_for_processes_named = {}

local action = wezterm.action

local function get_relative_pane(window, direction)
	local tab = window:mux_window():active_tab()
	return tab:get_pane_direction(direction)
end

config.keys = {
	{
		key = "f",
		mods = "LEADER",
		action = action.TogglePaneZoomState,
	},

	{
		key = "t",
		mods = "LEADER",
		action = action.SpawnTab("DefaultDomain"),
	},

	{
		key = "c",
		mods = "LEADER",
		action = action.CloseCurrentTab({ confirm = true }),
	},

	{
		key = "q",
		mods = "LEADER",
		action = action.PaneSelect({
			alphabet = "0123456789",
		}),
	},

	{
		key = "x",
		mods = "LEADER",
		action = action.CloseCurrentPane({ confirm = true }),
	},

	{
		key = "h",
		mods = "LEADER|SHIFT",
		action = action.SplitPane({
			direction = "Left",
		}),
	},

	{
		key = "j",
		mods = "LEADER|SHIFT",
		action = action.SplitPane({
			direction = "Down",
		}),
	},

	{
		key = "k",
		mods = "LEADER|SHIFT",
		action = action.SplitPane({
			direction = "Up",
		}),
	},

	{
		key = "l",
		mods = "LEADER|SHIFT",
		action = action.SplitPane({
			direction = "Right",
		}),
	},
	{
		key = "h",
		mods = "LEADER",
		action = wezterm.action_callback(function(window, pane)
			local relative = get_relative_pane(window, "Left")
			if relative then
				window:perform_action(
					action.AdjustPaneSize({ "Left", math.floor(relative:get_dimensions().cols / 3) }),
					pane
				)
			else
				relative = get_relative_pane(window, "Right")
				if relative then
					window:perform_action(
						action.AdjustPaneSize({ "Left", math.floor(pane:get_dimensions().cols / 3) }),
						relative
					)
				end
			end
		end),
	},
	{
		key = "j",
		mods = "LEADER",
		action = wezterm.action_callback(function(window, pane)
			local relative = get_relative_pane(window, "Down")
			if relative then
				window:perform_action(
					action.AdjustPaneSize({ "Down", math.floor(relative:get_dimensions().viewport_rows / 3) }),
					pane
				)
			else
				relative = get_relative_pane(window, "Up")
				if relative then
					window:perform_action(
						action.AdjustPaneSize({ "Down", math.floor(pane:get_dimensions().viewport_rows / 3) }),
						relative
					)
				end
			end
		end),
	},

	{
		key = "k",
		mods = "LEADER",
		action = wezterm.action_callback(function(window, pane)
			local relative = get_relative_pane(window, "Up")
			if relative then
				window:perform_action(
					action.AdjustPaneSize({ "Up", math.floor(relative:get_dimensions().viewport_rows / 3) }),
					pane
				)
			else
				relative = get_relative_pane(window, "Down")
				if relative then
					window:perform_action(
						action.AdjustPaneSize({ "Up", math.floor(pane:get_dimensions().viewport_rows / 3) }),
						relative
					)
				end
			end
		end),
	},

	{
		key = "l",
		mods = "LEADER",
		action = wezterm.action_callback(function(window, pane)
			local relative = get_relative_pane(window, "Right")
			if relative then
				window:perform_action(
					action.AdjustPaneSize({ "Right", math.floor(relative:get_dimensions().cols / 3) }),
					pane
				)
			else
				relative = get_relative_pane(window, "Left")
				if relative then
					window:perform_action(
						action.AdjustPaneSize({ "Right", math.floor(pane:get_dimensions().cols / 3) }),
						relative
					)
				end
			end
		end),
	},

	{
		key = "d",
		mods = "LEADER|SHIFT",
		action = action.ShowDebugOverlay,
	},
}

for i = 0, 7 do
	table.insert(config.keys, {
		key = tostring(i),
		mods = "LEADER",
		action = action.ActivateTab(i),
	})
end

config.color_scheme = "Atelier Dune (base16)"

return config
