# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ customPackages, home-manager, agenix, nix-snapd, config, inputs, pkgs, lib, self, system, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      home-manager.nixosModules.home-manager
      ../../home/cosmic.nix
      # ../../home/plasma.nix
      # ../../home/gnome.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.supportedFilesystems = [ "ntfs" ];
  boot.kernel.sysctl = {
    "fs.inotify.max_user_instances" = 4096;
    "fs.inotify.max_user_watches" = 524288;
  };

  
  programs.hyprland = {
    enable = false;
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;
  };

  security.pam.loginLimits = with lib;
    flip concatMap [ "*" "root" ] (domain:
    flip concatMap [ "nproc" "nofile" ] (item:
    flip       map [ "soft" "hard"](type:
      { inherit domain; inherit item; inherit type; value = "65536"; }
    )));


  nix.settings = {
    experimental-features = ["nix-command" "flakes"];
  };

  nix.extraOptions = ''
    keep-outputs = true
    keep-derivations = true
  '';

  age = {
    secrets.laptop.file = ../../secrets/laptop.age;
    secrets.backup-pass.file = ../../secrets/backup-pass.age;
    secrets.restic-env.file = ../../secrets/restic-env.age;
  };
  
  services.restic.backups = {
    denali = {
      initialize = true;
      passwordFile = config.age.secrets.backup-pass.path;
      repository = "s3:https://ewr1.vultrobjects.com/denali";
      environmentFile = config.age.secrets.restic-env.path;
      extraBackupArgs = [
        "--exclude-file=${./backupignore}"
      ];
      paths = [
        "/home"
      ];
      pruneOpts = [ 
        "--keep-daily 7"
        "--keep-weekly 4"
        "--keep-monthly 3"
      ];
    };
  };


  networking.hostName = "denali"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  # networking.nameservers = [ "192.168.0.28" "1.1.1.1" ];

  # Set your time zone.
  time.timeZone = "America/New_York";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
    useXkbConfig = false; # use xkbOptions in tty.
  };

  services.sshd.enable = true;
  services.udisks2.enable = true;

  services.snap.enable = true;

  services.fprintd.enable = false;
  # services.fprintd.package = (pkgs.callPackage ../home-manager/pkgs/fprintd.nix 
  services.fprintd.package = (pkgs.callPackage ../../pkgs {}).fprintd;
  # systemd.services."fprintd".serviceConfig = {
  #   ExecStart = "${pkgs.fprintd}/libexec/fprintd";
  #   Type = "dbus";
  #   BusName = "net.reactivated.Fprint";
  # };
  # services.fprintd.package = (pkgs.callPackage ../../pkgs {}).fprintd;

  
  # Enable the X11 windowing system.
  # services.xserver.enable = true;
  services.udev.extraRules = ''
    KERNEL=="uinput", MODE="0660", GROUP="uinput", OPTIONS+="static_node=uinput"
    ACTION=="add", SUBSYSTEM=="backlight", RUN+="${pkgs.coreutils}/bin/chgrp video $sys$devpath/brightness", RUN+="${pkgs.coreutils}/bin/chmod g+w $sys$devpath/brightness"

    # Arduino Uno
    SUBSYSTEM=="tty", GROUP="plugdev". MODE="0660"

    SUBSYSTEMS=="usb", ATTRS{idVendor}=="2341", ATTRS{idProduct}=="0043", SYMLINK+="arduino"
  '';
  # services.logind.lidSwitch = "suspend";
  services.tlp = {
    enable = false;
    extraConfig = ''
      CPU_SCALING_GOVERNOR_ON_AC=performance
      CPU_SCALING_GOVERNOR_ON_BAT=powersave
      RUNTIME_PM_ON_AC=on
      RUNTIME_PM_ON_BAT=auto
    '';
  };

  services.printing.enable = true;
  services.avahi.enable = true;
  services.avahi.nssmdns = true;
  services.avahi.openFirewall = true;
  services.upower.enable = true;

  services.dbus.packages = [
    pkgs.upower
  ];

  fonts = {
    fontDir.enable = true;
    fonts = with pkgs; [
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji
      noto-fonts-extra
      iosevka-bin
      meslo-lgs-nf
      font-awesome
      material-symbols
      victor-mono
      (nerdfonts.override { fonts = [ "Iosevka" ]; })
    ];
  };


  virtualisation = {
    libvirtd.enable = true;
    spiceUSBRedirection.enable = true;
    waydroid.enable = true;
    # lxd.enable = true;
  };

  zramSwap = {
    enable = true;
    priority = 10;
  };
  

  # Configure keymap in X11
  # services.xserver.layout = "us";
  # services.xserver.xkbOptions = {
  #   "eurosign:e";
  #   "caps:escape" # map caps to escape.
  # };

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  # sound.enable = true;
  # hardware.pulseaudio.enable = true;
  nixpkgs.config.packageOverrides = pkgs: {
    vaapiIntel = pkgs.vaapiIntel.override { enableHybridCodec = true; };
  };
  nixpkgs.config.allowUnfree = true;
  
  hardware.opengl = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver
      vaapiIntel
      vaapiVdpau
      libvdpau-va-gl
      intel-compute-runtime
    ];
  };

  hardware.opentabletdriver.enable = true;

  hardware.bluetooth.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  programs.zsh.enable = true;
  programs.nh = {
    enable = true;
    flake = "/home/riley/dotfiles/";
  };
  # programs.nushell.enable = true;
  users.users.riley = {
    isNormalUser = true;
    passwordFile = config.age.secrets.laptop.path;
    extraGroups = [ "wheel" "networkmanager" "input" "uinput" "video" "libvirtd" "dialout" "plugdev" "adbusers" ];
    home = "/home/riley";
    shell = pkgs.zsh;
    packages = with pkgs; [
      swaylock
    ];
  };

  # home-manager.nixosModules.home-manager = {
  home-manager = {
    # users.riley = import ./home.nix { inherit self pkgs inputs lib system customPackages;};
    backupFileExtension = "bak";
    extraSpecialArgs =  {inherit self inputs system;} ;
    users.riley.imports = [
      ./home.nix
    ];
  };

  programs.adb.enable = true;

  programs.dconf.enable = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    # vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    agenix.packages.x86_64-linux.default
    helix
    networkmanager
    wget
    pciutils
    virt-manager
  ];

  # environment.etc = {
  #   "wireplumber/bluetooth.lua.d/51-bluez-config.lua".text = ''
  #     bluez_monitor.properties = {
  #       ["bluez5.enable-sbc-xq"] = true,
  #       ["bluez5.enable-msbc"] = true,
  #       ["bluez5.enable-hw-volume"] = true,
  #       ["bluez5.headset-roles"] = "[ hsp_hs hsp_ag hfp_hf hfp_ag ]"
  #     }
  #   '';
  # };

  security.rtkit.enable = true;
  security.pam.services.swaylock = {};
  security.polkit.enable = true;

  hardware.pulseaudio.enable = false;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.11"; # Did you read the comment?

}

