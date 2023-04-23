{ pkgs, ... }: {
  systemd.user.services = {
    polkit-gnome-agent = {
      Unit = {
        Description = "polkit-gnome-agent";
        After = "graphical-session.target";
      };
      Install = {
        WantedBy = [ "graphical-session.target" ];
        Wants = [ "graphical-session.target" ];
      };
      Service = {
        Type = "simple";
        ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
        Restart = "on-failure";
        RestartSec = 1;
        TimoutStopSec = 10;
      };
    };
    mpris-proxy = {
      Unit = {
        Description = "Mpris proxy";
        After = [ "network.target" "sound.target" ];
      };
      Service.ExecStart = "${pkgs.bluez}/bin/mpris-proxy";
      Install.WantedBy = [ "default.target" ];
    };

    kanata = {
      Unit = {
        Description = "Kanata keyboard remapper";
        Documentation = "https://github.com/jtroo/kanata";
      };
      Service = {
        Type = "simple";
        ExecStart = "/home/riley/.nix-profile/bin/kanata --cfg /home/riley/.config/kanata.kbd";
      };
      Install = {
        WantedBy = [ "default.target" ];
      };
    };

    gestures = {
      Unit = {
        Description = "Touchpad gestures program";
        Documentation = "https://github.com/riley-martin/gestures";
      };
      Service = {
        Environment = [
          "HOME=/home/riley"
          "PATH=/home/riley/.nix-profile/bin:/run/current-system/sw/bin"
        ];
        Type = "simple";
        ExecStart = "/home/riley/.nix-profile/bin/gestures start";
      };
      Install = {
        WantedBy = [ "default.target" ];
      };
    };
  };
}
