{ ... }:
{
	programs.wezterm = {
		enable = true;
		extraConfig = ''
			local wezterm = require 'wezterm'
			local config = {}

			if wezterm.config_builder then
				config = wezterm.config_builder()
			end

			config = {
				hide_mouse_cursor_when_typing = false,
				enable_scroll_bar = true,
				hide_tab_bar_if_only_one_tab = true,
				window_background_opacity = 0.6,
				font = wezterm.font 'Iosevka Nerd Font',
				font_size = 11,
			}

			return config
		'';
	};
}
