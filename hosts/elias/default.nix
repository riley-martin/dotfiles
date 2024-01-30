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
    ];

  nixpkgs.config.allowUnfree = true;

  nixpkgs.config.permittedInsecurePackages = [
    "qtwebkit-5.212.0-alpha4"
  ];

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  # boot.loader.grub.efiSupport = true;
  # boot.loader.grub.efiInstallAsRemovable = true;
  # boot.loader.efi.efiSysMountPoint = "/boot/efi";
  # Define on which hard drive you want to install Grub.
  boot.loader.grub.device = "/dev/sda"; # or "nodev" for efi only

  networking.hostName = "elias"; # Define your hostname.

  age = {
    secrets.backup-pass.file = ../../secrets/backup-pass.age;
    secrets.ddns_tok.file = ../../secrets/ddns_tok.age;
    secrets.mailpass.file = ../../secrets/mailpass.age;
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
  
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  # networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.
  # networking.hosts = {
  #   "0.0.0.0" = [
  #     "builds.srht.local"
  #     "git.srht.local"
  #     "hub.srht.local"
  #     "logs.srht.local"
  #     "man.srht.local"
  #     "meta.srht.local"
  #     "srht.local"
  #   ];
  # };
  
  # Set your time zone.
  # time.timeZone = "Europe/Amsterdam";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";
  
  # services.logind.extraConfig = "HandleLidSwitch=ignore";
  services.logind.lidSwitch = "ignore";

  services.restic.backups = {
    localbackup = {
      backupPrepareCommand = ''
        mkdir -p /mnt/backup
        ${pkgs.mount}/bin/mount /dev/disk/by-label/backup /mnt/backup
      '';
      initialize = true;
      # passwordFile = "/etc/nixos/backup-pass";
      passwordFile = config.age.secrets.backup-pass.path;
      paths = [
        "/etc"
        "/var"
        "/home"
        "/usr"
        "/srv"
      ];
      repository = "/mnt/backup/server";
      backupCleanupCommand = ''
        ${pkgs.umount}/bin/umount /dev/disk/by-label/backup
      '';
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
  
  # services.cloudflared = {
  #   enable = false;
  #   tunnels = {
  #     "1c8eccd8-ba4a-42cf-9285-73c190d6489c" = {
        # credentialsFile = "/etc/nixos/006588ea-bae6-4451-ae20-aa705a265308.json";
  #       default = "http_status:404";
  #       ingress = {
  #         "*.rileymartin.xyz" = {
  #           service = "http://localhost";
  #         };
  #       };
  #     };
  #   };
  # };

  services.cloudflare-dyndns = {
    enable = true;
    ipv4 = true;
    # ipv6 = true;
    proxied = false;
    domains = [
      "cloud.rileymartin.xyz"
      "office.rileymartin.xyz"
    ];
    # apiTokenFile = "/etc/nixos/ddns_tok";
    apiTokenFile = config.age.secrets.ddns_tok.path;
  };

  services.jellyfin = {
    enable = true;
    openFirewall = true;
  };

  services.odoo = {
    enable = false;
    domain = "odoo.rileymartin.xyz";
    package = (pkgs.callPackage ../../pkgs {}).odoo;
    settings = {
      options = {
        admin_passwd = builtins.readFile config.age.secrets.pgsql-pass.path;
        db_user = "odoo";
        db_password = builtins.readFile config.age.secrets.pgsql-pass.path;
        # dbfilter = "^odoo.*$";
        dbfilter = ".*";
        addons_path = "/opt/odoo/custom_addons, /opt/odoo/custom_addons/CybroAddons, /nix/store/xv7kq744zwgpvjfc8np5s3s6qwkzp2gy-odoo-16.0.20231024/lib/python3.10/site-packages/odoo/addons, /var/lib/private/odoo/.local/share/Odoo/addons/16.0";
      };
    };
    addons = [
      # (pkgs.python3Packages.buildPythonPackage rec {
      #   pname = "odoo-addons-oca-account-financial-reporting";
      #   version = "16.0.20230919.0";
      #   src = pkgs.fetchFromGitHub {
      #     # inherit pname version;
      #     owner = "OCA";
      #     repo = "account-financial-reporting";
      #     rev = "16.0";
      #     sha256 = "sha256-im3PjewsMviH+8tXylbANVbVBUgPwiT5TSkOyqGlwYs=";
      #   };
      #   doCheck = false;
      #   nativeBuildInputs = [ pkgs.python3Packages.setuptools-odoo ];})
    ];
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
      {
        name = "odoo";
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
    # certs."cloud.rileymartin.xyz".extraDomainNames = [ "office.rileymartin.xyz" ];
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
          domain = "cloud.rileymartin.xyz";
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
  networking.firewall.enable = false;
  networking.enableIPv6 = true;
  # networking.firewall.allowedTCPPorts = [];

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

