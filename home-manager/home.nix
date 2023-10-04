{ self, system, pkgs, lib, ... }:
let
  nixpkgs = import <nixpkgs> {};
  hey = pkgs.writers.writeHaskellBin
    "hey"
    { libraries = [ pkgs.haskellPackages.cmdargs ]; }
    (builtins.readFile ./hey);
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

  xdg.enable = true;
  xdg.configFile."Kvantum/kvantum.kvconfig".text = ''
    [General]
    theme=MateriaDark
  '';

  gtk = {
    enable = true;
    iconTheme = {
      package = pkgs.papirus-icon-theme;
      name = "Papirus-Dark";
    };
    theme = {
      package = pkgs.materia-theme;
      name = "Materia-dark-compact";
    };
  };

  home.sessionVariables = {
    QT_STYLE_OVERRIDE = "kvantum";
    GTK_USE_PORTAL = 1;
    WLR_DRM_NO_MODIFIERS = 1;
  };

  home.packages = with pkgs; [
    ## Command line utilities
    hey progress libnotify zip unzip sl bashInteractive s-tui
    dig lynx delta bat lsd ripgrep fd bottom tealdeer
    self.inputs.nix-alien.packages.${system}.nix-alien
    traceroute restic itd

    ## Gui/Desktop environment utilities
    imv xdg-utils wluma swayidle
    (callPackage ./pkgs/chromium-flagfile.nix { inherit pkgs; })
    (callPackage ./pkgs/fprint-eh575.nix {inherit lib;})
    self.inputs.gestures.packages.${system}.gestures
    kanata wl-clipboard brillo wpaperd rofi-wayland jamesdsp dconf
    materia-kde-theme libsForQt5.qtstyleplugin-kvantum
    joplin-desktop

    ## Development tools
    gh nil age

    ## Graphics
    darktable freecad blender hugin
    (callPackage ../pkgs{}).gimp-devel

    ## Office
    libreoffice-fresh

    ## Other
    stellarium
  ]
  # Deps for eww scripts
  #TODO: move this to eww `default.nix`
  ++
  [
    bash
    blueberry
    bluez
    brillo
    coreutils
    dbus
    findutils
    gawk
    gnome.gnome-control-center
    gnused
    imagemagick
    jaq
    jc
    libnotify
    networkmanager
    pavucontrol
    playerctl
    procps
    pulseaudio
    ripgrep
    socat
    udev
    upower
    util-linux
    wget
    wireplumber
    wlogout
  ];

  imports = [
    ./services.nix
    ./zsh.nix
    ./hyprland.nix
    ./helix.nix
    # ./alacritty.nix
    # ./waybar.nix
    ./wezterm.nix
    ./nushell.nix
    ./dunst.nix
    ./eww
    ./alacritty.nix
    # ./ironbar.nix
  ];

  services.udiskie = {
    enable = true;
  };

  programs.chromium.commandLineArgs = [
    "--force-dark-mode"
    "--enable-features='WebUIDarkMode,TouchpadOverscrollHistoryNavigation'"
    "--ozone-platform=wayland"
  ];

  programs.eww = {
    enable = true;
    package = pkgs.eww-wayland;
    # package = (pkgs.callPackage ./eww { inherit pkgs; });
    configDir = ./eww/sidebar;
  };

  # programs.eww-hyprland = {
    # enable = true;
    # autoReload = true;
  # };

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
