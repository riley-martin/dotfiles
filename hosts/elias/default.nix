# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ agenix, config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      # ./mailz.nix
      ../../system/nextcloud.nix
      ../../system/nginx-elias.nix
      ../../system/fail2ban.nix
      ../../system/immich.nix
      ../../system/audiobookshelf.nix
      ../../system/subsonic.nix
    ];

  nixpkgs.config.allowUnfree = true;

  nixpkgs.config.permittedInsecurePackages = [
    "qtwebkit-5.212.0-alpha4"
  ];

  # Use the GRUB 2 boot loader.
  # boot.loader.grub.enable = true;
  # boot.loader.grub.efiSupport = true;
  # boot.loader.grub.efiInstallAsRemovable = true;
  # boot.loader.efi.efiSysMountPoint = "/boot/efi";
  # Define on which hard drive you want to install Grub.
  # boot.loader.grub.device = "/dev/sda"; # or "nodev" for efi only

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "elias"; # Define your hostname.

  age = {
    # secrets.nextcloud-mail.file = ../../secrets/nextcloud-mail.age;
    secrets.backup-pass.file = ../../secrets/backup-pass.age;
    secrets.ddns_tok.file = ../../secrets/ddns_tok.age;
    secrets.mailpass.file = ../../secrets/mailpass.age;
    secrets.rclone-config.file = ../../secrets/rclone-config.age;
    secrets.restic-env.file = ../../secrets/restic-env.age;
    secrets.vaultwarden-env = {
      file = ../../secrets/vaultwarden-env.age;
      mode = "770";
      owner = "vaultwarden";
      group = "vaultwarden";
    };
    secrets.nextcloud-admin-pass = {
      file = ../../secrets/nextcloud-admin-pass.age;
      mode = "770";
      owner = "nextcloud";
      group = "nextcloud";
    };
    secrets.onlyoffice_secret.file = ../../secrets/onlyoffice_secret.age;
    secrets.pgsql-pass = {
      file = ../../secrets/pgsql-pass.age;
      mode = "770";
      owner = "nextcloud";
      group = "nextcloud";
    };
  };
  
  # time.timeZone = "Europe/Amsterdam";

  services.logind.lidSwitch = "ignore";

  services.restic.backups = {
    elias = {
      initialize = true;
      passwordFile = config.age.secrets.backup-pass.path;
      repository = "s3:https://ewr1.vultrobjects.com/elias";
      environmentFile = config.age.secrets.restic-env.path;
      paths = [
        "/etc"
        "/var"
        "/home"
        "/usr"
        "/srv"
        "/mnt"
      ];
      pruneOpts = [ 
        "--keep-daily 7"
        "--keep-weekly 4"
        "--keep-monthly 3"
      ];
      extraBackupArgs = [ "--no-scan" ];
      timerConfig = {
        OnCalender = "daily";
        Persistent = true;
      };
    };
  };
  
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;
  };
  
  services.home-assistant = {
    enable = false;
    config = {};
    configWritable = true;
  };

  services.cloudflare-dyndns = {
    enable = true;
    ipv4 = true;
    # ipv6 = true;
    proxied = false;
    domains = [
      "cloud.rileymartin.dev"
      "office.rileymartin.dev"
      "warden.rileymartin.dev"
    ];
    apiTokenFile = config.age.secrets.ddns_tok.path;
  };

  services.vaultwarden = {
    enable = true;
    environmentFile = config.age.secrets.vaultwarden-env.path;
    config = {
      rocketAddress = "127.0.0.1";
      rocketPort = 8222;
    };
  };

  services.jellyfin = {
    enable = true;
    openFirewall = true;
  };

  services.postgresql = {
    enable = true;
    ensureDatabases = [ "nextcloud" "odoo" ];
    ensureUsers = [
      {
        name = "nextcloud";
        # ensurePermissions."DATABASE nextcloud" = "ALL PRIVILEGES";
        ensureDBOwnership = true;
      }
    ];
  };

  systemd.services."nextcloud-setup" = {
    requires = [ "postgresql.service" ];
    after = [ "postgresql.service" ];
  };

  security.acme = {
    acceptTerms = true;
    defaults.email = "rileyseanm@gmail.com";
  };

  virtualisation.oci-containers = {
      # Since 22.05, the default driver is podman but it doesn't work
      # with podman. It would however be nice to switch to podman.
      backend = "docker";
      containers.collabora = {
        image = "collabora/code";
        imageFile = pkgs.dockerTools.pullImage {
          imageName = "collabora/code";
          imageDigest = "sha256:3660e56e1974f4fbe08fac35bad577e6a1836e72f5090117bffe9702f3cea165";
          sha256 = "0xvjl0r4nnldhz6wa6q422vniqvgigw5vbvw48fn57m5173knyrh";
        };
        ports = ["9980:9980"];
        environment = {
          domain = "office.rileymartin.dev";
          extra_params = "--o:ssl.enable=false --o:ssl.termination=true --o:net.post_allow.host='.*' --o:storage.wopi.host='.*'";
        };
        extraOptions = ["--cap-add" "MKNOD"];
      };
 
    };


  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "dvorak-programmer";
    useXkbConfig = false; # use xkbOptions in tty.
  };

  # Enable the X11 windowing system.
  # services.xserver.enable = true;
  
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

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

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.riley = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    packages = with pkgs; [
    ];
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    helix # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    curl
    bottom
    git
    jellyfin
    jellyfin-web
    jellyfin-ffmpeg
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:
  
  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  services.openssh.settings.PasswordAuthentication = false;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = true;
  networking.firewall.allowedTCPPorts = [80 443];
  networking.enableIPv6 = true;

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

