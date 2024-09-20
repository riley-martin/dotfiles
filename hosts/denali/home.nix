{ customPackages, self, system, inputs, pkgs, lib, ... }:
let
  nixpkgs = import ../../nixpkgs.nix {};
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
      "ungoogled-chromium-unwrapped"
      "chromium-unwrapped"
      "chrome-widevine-cdm"
      "widevine-cdm"
      "cuda_nvcc-11.8.89"
      "cudatoolkit"
      "davinci-resolve"
      "Anytype-0.38.0"
      "android-studio-stable"
    ];
    chromium = {
      enableWideVine = true;
      channel = "stable";
    };
  };

  # formatter.system = pkgs.alejandra;

  xdg.enable = true;
  # xdg.configFile."Kvantum/kvantum.kvconfig".text = ''
  #   [General]
  #   theme=MateriaDark
  # '';

  gtk = {
    enable = true;
    # iconTheme = {
    #   # package = pkgs.papirus-icon-theme;
    #   # name = "Papirus-Dark";
    #   package = pkgs.materia-theme;
    #   name = "Materia-dark-icons";
    # };
    # theme = {
    #   package = pkgs.materia-theme;
    #   name = "Materia-dark-compact";
    # };
  };

  # home.pointerCursor = {
  #   gtk.enable = true;
  #   package = pkgs.gnome.adwaita-icon-theme;
  #   name = "Adwaita";
  #   size = 16;
  # };

  home.sessionVariables = {
    # QT_STYLE_OVERRIDE = "kvantum";
    GTK_USE_PORTAL = 0;
    WLR_DRM_NO_MODIFIERS = 1;
    FLAKE = "/home/riley/dotfiles";
  };

  home.packages = with pkgs; [
    ## Command line utilities
    hey progress libnotify zip unzip sl bashInteractive s-tui
    dig lynx bat lsd ripgrep fd bottom tealdeer
    self.inputs.nix-alien.packages.${system}.nix-alien
    traceroute restic itd

    ## Gui/Desktop environment utilities
    imv xdg-utils wluma swayidle
    (callPackage ../../pkgs{}).chromium-flagfile
    (callPackage ../../pkgs{}).fprint-eh575
    # self.inputs.gestures.packages.${system}.gestures
    kanata wl-clipboard brillo wpaperd rofi-wayland jamesdsp dconf
    materia-kde-theme libsForQt5.qtstyleplugin-kvantum
    keepassxc signal-desktop bitwarden
    gnome.gnome-boxes
    kitty iotas scrcpy
    handbrake spotube

    ## Development tools
    gh nil age vscodium android-studio

    ## Graphics
    digikam exiftool darktable freecad blender hugin
    (callPackage ../../pkgs{}).gimp-devel
    # gimp
    kdenlive inkscape audacity

    ## Office
    libreoffice-qt6-fresh

    ## Other
    stellarium
  ];

  imports = [
    ../../home/services.nix
    ../../home/zsh.nix
    # ../../home/hyprland.nix
    ../../home/helix.nix
    # ./alacritty.nix
    # ./waybar.nix
    # ../../home/terminals/wezterm.nix
    ../../home/nushell.nix
    # ../../home/dunst.nix
    ../../home/eww
    ../../home/terminals/alacritty.nix
    ../../home/terminals/rio.nix
    # ./ironbar.nix
    ../../home/video.nix
  ];

  # services.kdeconnect.enable = true;

  services.mpd = {
    enable = true;
    musicDirectory = "/home/riley/Music";
    extraConfig = ''
      audio_output {
        type "pipewire"
        name "PipeWire Output"
      }
    '';
  };

  # services.udiskie = {
  #   enable = true;
  # };

  programs.chromium.commandLineArgs = [
    "--force-dark-mode"
    "--enable-features='WebUIDarkMode,TouchpadOverscrollHistoryNavigation'"
    "--ozone-platform=wayland"
  ];

  programs.eww = {
    enable = false;
    package = pkgs.eww-wayland;
    # package = (pkgs.callPackage ./eww { inherit pkgs; });
    configDir = ../../home/eww/sidebar;
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
    includes = [ { path = ../../home/gitconfig; } ];
  };

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.broot.enable = true;

  programs.starship = {
    enable = true;
  };

  services.syncthing.enable = true;
}
