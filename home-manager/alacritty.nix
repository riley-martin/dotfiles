{ ... }: {
	programs.alacritty = {
		enable = true;
		settings = {
			dynamic_title = true;
			font = {
				normal.family = "Iosevka";
			};
		};
	};
}
