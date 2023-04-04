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
      "ungoogled-chromium"
      "chromium-unwrapped"
      "chrome-widevine-cdm"
    ];
    chromium = {
      enableWideVine = true;
      channel = "stable";
    };
  };

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

    ## Gui/Desktop environment utilities
    pkgs.xdg-utils
    pkgs.wluma
    pkgs.swayidle
    (pkgs.callPackage ./pkgs/chromium-flagfile.nix {})
    (pkgs.callPackage ./pkgs/gestures.nix {})
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
    # ./ironbar.nix
  ];

  services.dunst.enable = true;

  programs.chromium.commandLineArgs = [
    "--force-dark-mode"
    "--enable-features='WebUIDarkMode,TouchpadOverscrollHistoryNavigation'"
    "--ozone-platform=wayland"
  ];
  
  programs.git = {
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
