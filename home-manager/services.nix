{ pkgs, ... }: {
  systemd.user.services = {
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
        ExecStart = "/home/riley/.nix-profile/bin/gestures";
      };
      Install = {
        WantedBy = [ "default.target" ];
      };
    };
  };
}
