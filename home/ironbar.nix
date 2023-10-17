{ ... }: {
	programs.ironbar = {
		enable = true;
		# package = inputs.ironbar;
		features = [ "default" ];
		config = let

			launcher = {
				type = "launcher";
				show_names = false;
				show_icons = true;
			};
			workspaces = {
				type = "workspaces";
				all_monitors = false;
			};
			music.type = "music";
			sys_info = {
				type = "sys_info";
				format = ["{cpu_percent}%"];
			};

			left = [
				workspaces
				launcher
				music
			];
			middle = [
				{ type = "focused"; }
			];
			right = [
				{ type = "tray"; }
				sys_info
				{ type = "clipboard"; }
				{ type = "clock"; }
			];
		in {
			position = "top";
			height = 42;
			start = left;
			center = middle;
			end = right;
		};
		style = ''
			* {
          /* `otf-font-awesome` is required to be installed for icons */
          /*font-family: Noto Sans Nerd Font, sans-serif;*/
          font-family: monospace;
          font-size: 16px;
          /*color: white;*/
          /*background-color: #2d2d2d;*/
          /*background-color: red;*/
          border: none;
          /*opacity: 0.4;*/
      }
      #bar {
          border-top: 1px solid #424242;
      }
      .container {
          background-color: #2d2d2d;
      }
      /* test  34543*/
      #right > * + * {
          margin-left: 20px;
      }
      #workspaces .item {
          color: white;
          background-color: #2d2d2d;
          border-radius: 0;
      }
      #workspaces .item.focused {
          box-shadow: inset 0 -3px;
          background-color: #1c1c1c;
      }
      #workspaces *:not(.focused):hover {
          box-shadow: inset 0 -3px;
      }
      #launcher .item {
          border-radius: 0;
          background-color: #2d2d2d;
          margin-right: 4px;
      }
      #launcher .item:not(.focused):hover {
          background-color: #1c1c1c;
      }
      #launcher .open {
          border-bottom: 2px solid #6699cc;
      }
      #launcher .focused {
          color: white;
          background-color: black;
          border-bottom: 4px solid #6699cc;
      }
      #launcher .urgent {
          color: white;
          background-color: #8f0a0a;
      }
      #clock {
          color: white;
          background-color: #2d2d2d;
          font-weight: bold;
      }
      #script {
          color: white;
      }
      #sysinfo {
          color: white;
      }
      #tray .item {
          background-color: #2d2d2d;
      }
      #mpd {
          background-color: #2d2d2d;
          color: white;
      }
      .popup {
          background-color: #2d2d2d;
          border: 1px solid #424242;
      }
      #popup-clock {
          padding: 1em;
      }
      #calendar-clock {
          color: white;
          font-size: 2.5em;
          padding-bottom: 0.1em;
      }
      #calendar {
          background-color: #2d2d2d;
          color: white;
      }
      #calendar .header {
          padding-top: 1em;
          border-top: 1px solid #424242;
          font-size: 1.5em;
      }
      #calendar:selected {
          background-color: #6699cc;
      }
      #popup-mpd {
          color: white;
          padding: 1em;
      }
      #popup-mpd #album-art {
          /*border: 1px solid #424242;*/
          margin-right: 1em;
      }
      #popup-mpd #title .icon, #popup-mpd #title .label {
          font-size: 1.7em;
      }
      #popup-mpd #controls * {
          border-radius: 0;
          background-color: #2d2d2d;
          color: white;
      }
      #popup-mpd #controls *:disabled {
          color: #424242;
      }
      #focused {
          color: white;
      }
		'';
	};
}
