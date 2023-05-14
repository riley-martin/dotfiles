{...}: {
	services.dunst = {
		enable = true;
		settings = {
			global = {
				origin = "top-right";
				progress_bar_corner_radius = 4;
				icon_corner_radius = 4;
				transparency = 10;
				corner_radius = 8;
				frame_width = 2;
				frame_color = "#1C2325";
				background = "#0D0F16";

				sort = true;
				ellipsize = true;
				bounce_freq = 4;
			};
		};
	};
}
