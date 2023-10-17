{ self, system, ... }: {
	programs.waybar = {
		enable = true;
		package = self.inputs.hyprland.packages.${system}.waybar-hyprland;
		style = ./waybar.css;
		settings = {
			mainBar = {
				layer = "top";
				height = 30;
				margin-top = 6;
				margin-left = 10;
				margin-right = 10;
				margin-bottom = 0;
				output = "eDP-1";
				spacing = 4;

		    modules-left = [ "custom/launcher" "cpu" "memory" "wlr/workspaces" "custom/weather" ];
		    modules-center = [ "hyprland/window" ];
		    modules-right = [ "tray" "backlight" "wireplumber" "network" "bluetooth" "battery" "clock" "custom/power-menu" ];

		    "wlr/workspaces" = {
		      format = "{icon}";
		      on-click = "activate";
		      format-icons = {
		        "1" = " ";
		        "2" = "";
		        "3" = "";
		        "4" = "";
		        "5" = "";
		        urgent = "";
		        active = "";
		        default = "";
		      };
		    };
		    "hyprland/window" = {
		        format = "{}";
		        max-length = 32;
		    };
		    tray = {
		        icon-size = 16;
		        "spacing" = 10;
		        "show-passive-items" = true;
		    };

		    clock = {
		        format-alt = "<span color='#bf616a'> </span>{:%a %b %d}";
		        format = "<span color='#bf616a'> </span>{:%I:%M %p}";
		        tooltip-format = "<big>{:%B %Y}</big>\n<tt><small>{calendar}</small></tt>";
		    };

		    cpu = {
		      interval = 10;
		      format = " {usage}%";
		      max-length = 10;
		      on-click = "";
		    };
		    memory = {
		        interval = 30;
		        format = " {}%";
		        format-alt =" {used =0.1f}G";
		        max-length = 10;
		    };

		    backlight = {
		        device = "DP-1";
		        format = "{icon} {percent}%";
		        format-icons = [ "" "" "" "" "" "" "" "" "" ];
		        on-click = "";
		    };

		    network = {
		        # "interface": "wlan0",
		        format-wifi = "直 {signalStrength}%";
		        format-ethernet = " wired";
		        format-disconnected = "睊";
		        on-click = "bash ~/.config/waybar/scripts/rofi-wifi-menu.sh";
		        # "format-disconnected": "Disconnected  ",
		    };
		    wireplumber = {
		        format = "{icon} {volume}%";
		        on-click = "jamesdsp &";
		        format-muted = "婢";
		        format-icons = [ "" "" "" ];

		    };

		    pulseaudio = {
		        format = "{icon} {volume}%";
		        format-bluetooth = "  {volume}%";
		        format-bluetooth-muted = " ";
		        format-muted = "婢";
		        format-icons = {
		            headphone = "";
		            hands-free = "";
		            headset = "";
		            phone = "";
		            portable = "";
		            car = "";
		            default = [ "" "" "" ];
		        };
		        on-click = "jamesdsp &";
		    };

		    bluetooth = {
		        on-click = "~/.config/waybar/scripts/rofi-bluetooth &";
		        format = " {status}";
		        format-off = "";
		        format-disabled = " disabled";
		        format-on = "";
		        format-connected = "";
		    };

		    battery = {
		      interval = 60;
		      states = {
		          warning = 30;
		          critical = 15;
		      };
		      max-length = 20;
		      format = "{icon} {capacity}%";
		      format-warning = "{icon} {capacity}%";
		      format-critical = "{icon} {capacity}%";
		      format-charging = "<span font-family='Font Awesome 6 Free'></span> {capacity}%";
		      format-plugged = "  {capacity}%";
		      format-alt = "{icon} {time}";
		      format-full = "  {capacity}%";
		      format-icons = [ " " " " " " " " " " ];
		    };

		    "custom/weather" = {
		      exec = "curl wttr.in/?format=2";
		      restart-interval = 300;
		      on-click = "xdg-open 'https://forecast.weather.gov/MapClick.php?lat=40.48178550556978&lon=-80.03597590979933'";
		    };   

				"custom/music" = {
					exec = "python3 ~/.config/waybar/scripts/mediaplayer.py";
					format = "{}  ";
					return-type = "json";
					on-click = "playerctl play-pause";
					on-double-click-right = "playerctl next";
					on-scroll-down = "playerctl previous";
		    };
		    "custom/power-menu" = {
	        format = " <span color='#6a92d7'>⏻ </span>";
	        on-click = "bash ~/.config/waybar/scripts/power-menu/powermenu.sh";
		    }; 
		    "custom/launcher" = {
		        format = " <span color='#6a92d7'> </span>";
		        on-click = "rofi -show drun";
		        # "on-click" = "onagre";
		    };
			};
		};
	};
}
