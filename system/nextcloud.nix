{ pkgs, config, ... }: {
    services.nextcloud = {
      enable = true;
      package = pkgs.nextcloud29;
      hostName = "elias";
      # hostName = "cloud.localhost";
      https = false;
      configureRedis = true;
      logType = "file";


      phpOptions = {
        "opcache.interned_strings_buffer" = "16";
      };
    
      config = {
        # adminpassFile = "/etc/nixos/nextcloud-admin-pass";
        adminpassFile = config.age.secrets.nextcloud-admin-pass.path;

        dbtype = "pgsql";
        dbuser = "nextcloud";
        dbhost = "/run/postgresql";
        dbname = "nextcloud";
        # dbpassFile = "/etc/nixos/pgsql-pass";
        dbpassFile = config.age.secrets.pgsql-pass.path;
      };

      extraOptions = {
        defaultPhoneRegion = "US";
        overwriteProtocol = "https";
        extraTrustedDomains = [
          "100.64.26.109"
          "127.0.0.1"
          "localhost"
          "elias"
          "192.168.0.10"
          "71.61.203.114"
          "cloud.rileymartin.xyz"
          "10.42.0.0/16"
          "103.21.244.0/22"
          "103.22.200.0/22"
          "103.31.4.0/22"
          "104.16.0.0/12"
          "108.162.192.0/18"
          "131.0.72.0/22"
          "141.101.64.0/18"
          "162.158.0.0/15"
          "172.64.0.0/13"
          "173.245.48.0/20"
          "188.114.96.0/20"
          "190.93.240.0/20"
          "197.234.240.0/22"
          "198.41.128.0/17"
          "2400:cb00::/32"
          "2606:4700::/32"
          "2803:f800::/32"
          "2405:b500::/32"
          "2405:8100::/32"
          "2c0f:f248::/32"
        ];
      };
      appstoreEnable = true;
      enableImagemagick = true;

    };
}
