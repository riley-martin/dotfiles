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
				enable_scroll_bar = true,
				font = wezterm.font 'Iosevka Nerd Font',
				font_size = 11,
			}

			return config
		'';
	};
}
