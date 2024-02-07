# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running `nixos-help`).

{ agenix, config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ../../system/fail2ban.nix
      (builtins.fetchTarball {
        url = "https://gitlab.com/simple-nixos-mailserver/nixos-mailserver/-/archive/nixos-23.05/nixos-mailserver-nixos-23.05.tar.gz";
        sha256 = "1ngil2shzkf61qxiqw11awyl81cr7ks2kv3r3k243zz7v2xakm5c";
      })
    ];

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  # boot.loader.grub.efiSupport = true;
  # boot.loader.grub.efiInstallAsRemovable = true;
  # boot.loader.efi.efiSysMountPoint = "/boot/efi";
  # Define on which hard drive you want to install Grub.
  boot.loader.grub.device = "/dev/vda"; # or "nodev" for efi only

  networking.hostName = "foraker"; # Define your hostname.
  networking.enableIPv6 = true;
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  # networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  # Set your time zone.
  # time.timeZone = "Europe/Amsterdam";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkbOptions in tty.
  # };

  # Enable the X11 windowing system.
  # services.xserver.enable = true;

  age = {
    secrets.mailserver.file = ../../secrets/mailserver.age;
    secrets.nextcloud-mail.file = ../../secrets/nextcloud-mail.age;
    secrets.connor-mail.file = ../../secrets/connor-mail.age;
  };

  mailserver = {
    enable = true;
    fqdn = "mail.rileymartin.dev";
    domains = [ "rileymartin.dev" "rileymartin.xyz" ];
    loginAccounts = {
      "me@rileymartin.dev" = {
        hashedPasswordFile = config.age.secrets.mailserver.path;
        aliases = [ "me@rileymartin.xyz" "signup@rileymartin.dev" "postmaster@rileymartin.dev" "riley-martin@rileymartin.dev" ];
      };
      "nextcloud@rileymartin.dev" = {
        hashedPasswordFile = config.age.secrets.mailserver.path;
        sendOnly = true;
      };
      "warden@rileymartin.dev" = {
        hashedPasswordFile = config.age.secrets.mailserver.path;
        sendOnly = true;
      };
      "connor@rileymartin.dev" = {
        hashedPasswordFile = config.age.secrets.connor-mail.path;
        aliases = [ "connor@rileymartin.xyz"];
      };
    };
    certificateScheme = "acme-nginx";
  };

  services.roundcube = {
    enable = true;
    hostName = "mail.rileymartin.xyz";
    extraConfig = ''
      $config['smtp_server'] = "tls://${config.mailserver.fqdn}";
      $config['smtp_user'] = "%u";
      $config['smtp_pass'] = "%p";
    '';
  };

  services.nginx.enable = true;

  security.acme = {
    acceptTerms = true;
    defaults.email = "rileyseanm@gmail.com";
  };


  

  # Configure keymap in X11
  # services.xserver.layout = "us";
  # services.xserver.xkbOptions = "eurosign:e,caps:escape";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  # sound.enable = true;
  # hardware.pulseaudio.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  # users.users.alice = {
  #   isNormalUser = true;
  #   extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
  #   packages = with pkgs; [
  #     firefox
  #     tree
  #   ];
  # };
  users.users.riley = {
    isNormalUser = true;
    initialPassword = "changeme";
    extraGroups = [ "wheel" ];
    openssh.authorizedKeys.keys = [
      (builtins.readFile ./key.pub)
    ];
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    agenix.packages.x86_64-linux.default
    curl
    helix
    git
    # vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  #   wget
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

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?

}

