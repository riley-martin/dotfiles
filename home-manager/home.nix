{ self, system, pkgs, lib, ... }:
let
  nixpkgs = import <nixpkgs> {};
in {
  home.username = "riley";
  home.homeDirectory = "/home/riley";
  home.stateVersion = "22.11";
  targets.genericLinux.enable = true;
  programs.home-manager.enable = true;
  # programs.plotinus.enable = true;

  nixpkgs.config = {
    # This sucks, but I sort of need widevine :(
    allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
      "chromium"
      "chromiumDev"
      "chromium-dev"
      "chromiumBeta"
      "chromium-beta"
      "ungoogled-chromium"
      "chromium-unwrapped"
      "chrome-widevine-cdm"
    ];
    chromium = {
      enableWideVine = true;
      channel = "stable";
    };
  };

  # formatter.system = pkgs.alejandra;

  xdg = {
    enable = true;
  };  

  home.packages = [
    ## Command line utilities
    pkgs.sl
    pkgs.bashInteractive
    pkgs.s-tui
    pkgs.dig
    pkgs.lynx
    pkgs.delta
    pkgs.bat
    pkgs.lsd
    pkgs.ripgrep
    # pkgs.handlr
    pkgs.fd
    pkgs.bottom
    self.inputs.nix-alien.packages.${system}.nix-alien
    pkgs.tealdeer

    ## Gui/Desktop environment utilities
    pkgs.imv
    pkgs.xdg-utils
    pkgs.wluma
    pkgs.swayidle
    (pkgs.callPackage ./pkgs/chromium-flagfile.nix {})
    (pkgs.callPackage ./pkgs/fprint-eh575.nix {inherit lib;})
    # (pkgs.callPackage ./pkgs/gimp-devel.nix {inherit pkgs;})
    self.inputs.gestures.packages.${system}.gestures
    # (pkgs.callPackage ./pkgs/gestures.nix {})

    pkgs.kanata
    pkgs.wl-clipboard
    pkgs.brillo
    # pkgs.waybar
    pkgs.wpaperd
    pkgs.rofi-wayland
    # pkgs.joplin-desktop
    pkgs.jamesdsp
    pkgs.dconf

    ## Development tools
    pkgs.rust-analyzer
    pkgs.gh
    pkgs.nil
    pkgs.age
    pkgs.zola
    pkgs.rustup
    pkgs.clang
    # pkgs.gcc
    pkgs.pkg-config

    ## Graphics
    pkgs.gimp
    pkgs.darktable

    ## Office
    pkgs.libreoffice-fresh

    ## Other
    pkgs.stellarium
  ];

  imports = [
    ./services.nix
    ./zsh.nix
    ./hyprland.nix
    ./helix.nix
    ./alacritty.nix
    ./waybar.nix
    ./wezterm.nix
    ./nushell.nix
    # ./ironbar.nix
  ];

  services.dunst.enable = true;

  programs.chromium.commandLineArgs = [
    "--force-dark-mode"
    "--enable-features='WebUIDarkMode,TouchpadOverscrollHistoryNavigation'"
    "--ozone-platform=wayland"
  ];

  programs.eww = {
    enable = true;
    package = pkgs.eww-wayland;
    configDir = ./eww;
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
  
  programs.git = {
    package = pkgs.gitFull;
    enable = true;
    includes = [ { path = ./gitconfig; } ];
  };

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.broot.enable = true;
  programs.starship = {
    enable = true;
  };
}
