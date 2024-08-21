{ pkgs, config, ... }: {
    services.nginx = {
      enable = true;
      virtualHosts."nextcloud" = {
        listen = [{
          addr = "100.106.82.60";
          port = 80;
        }];
      };
    };
    services.nextcloud = {
      enable = true;
      package = pkgs.nextcloud29;
      hostName = "nextcloud";
      # hostName = "cloud.localhost";
      https = false;
      configureRedis = true;
      logType = "file";

      settings.trusted_proxies = [
        "100.64.26.109"
        "fd7a:115c:a1e0::7701:1a6d"
      ];

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
        # overwriteProtocol = "https";
        overwriteHost = "100.64.26.109";
        extraTrustedDomains = [
          "cloud.rileymartin.dev"
          "100.106.82.60"
          "nextcloud"
          "foraker"
          "104.156.244.250"
          "100.64.26.109"
          "127.0.0.1"
          "localhost"
          "elias"
          "192.168.0.10"
          "71.61.203.114"
          "cloud.rileymartin.xyz"
        ];
      };
      appstoreEnable = true;
      enableImagemagick = true;

    };
}
