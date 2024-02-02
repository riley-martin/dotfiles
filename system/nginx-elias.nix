{ config, ... }: {
  services.nginx = {
    enable = true;
    logError = "stderr info";

    resolver.addresses = [ "[::1]" "127.0.0.1" "1.1.1.1"];

    # Use recommended settings
    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;

    # Only allow PFS-enabled ciphers with AES256
    sslCiphers = "AES256+EECDH:AES256+EDH:!aNULL";

    # Setup Nextcloud virtual host to listen on ports
    virtualHosts = {


      "cloud.rileymartin.xyz" = {
        ## Force HTTP redirect to HTTPS
        forceSSL = true;
        ## LetsEncrypt
        enableACME = true;
      };

      "warden.rileymartin.xyz" = {
        forceSSL = true;
        enableACME = true;
        locations."/" = {
          proxyPass = "http://127.0.0.1:${toString config.services.vaultwarden.config.ROCKET_PORT}";
        };
      };
      
      "office.rileymartin.xyz" = {
        forceSSL = true;
        enableACME = true;
        locations = {
          # static files
          "^~ /browser" = {
            proxyPass = "http://localhost:9980";
            extraConfig = ''
              proxy_set_header Host $host;
            '';
          };
          # WOPI discovery URL
          "^~ /hosting/discovery" = {
            proxyPass = "http://localhost:9980";
            extraConfig = ''
              proxy_set_header Host $host;
            '';
          };

          # Capabilities
          "^~ /hosting/capabilities" = {
            proxyPass = "http://localhost:9980";
            extraConfig = ''
              proxy_set_header Host $host;
            '';
          };

          "~ ^/cool/(.*)/ws$" = {
             proxyPass = "http://127.0.0.1:9980";
             extraConfig = ''
               proxy_set_header Upgrade $http_upgrade;
               proxy_set_header Connection "Upgrade";
               proxy_set_header Host $host;
               proxy_read_timeout 36000s;
            '';
           };


          # download, presentation, image upload and websocket
          # "~ ^/lool" = {
          #   proxyPass = "http://localhost:9980";
          #   extraConfig = ''
          #     proxy_set_header Upgrade $http_upgrade;
          #     proxy_set_header Connection "Upgrade";
          #     proxy_set_header Host $host;
          #     proxy_read_timeout 36000s;
          #   '';
          # };

          "~ ^/(c|l)ool" = {
            proxyPass = "http://localhost:9980";
            extraConfig = ''
              proxy_set_header Upgrade $http_upgrade;
              proxy_set_header Connection "Upgrade";
              proxy_set_header Host $host;
              proxy_read_timeout 36000s;
            '';
          };

          # Admin Console websocket
          "^~ /cool/adminws" = {
            proxyPass = "http://localhost:9980";
            extraConfig = ''
              proxy_set_header Upgrade $http_upgrade;
              proxy_set_header Connection "Upgrade";
              proxy_set_header Host $host;
              proxy_read_timeout 36000s;
            '';
          };
        };
      };

      "media.rileymartin.xyz" = {
        enableACME = true;
        forceSSL = true;
        # clientMaxBodySize = "20M";
        locations = {
          " = /" = {
            return = "302 https://$host/web";
          };
          "/" = {
            proxyPass = "http://192.168.0.10:8096";
            extraConfig = ''
              proxy_set_header Host $host;
              proxy_ssl_server_name on;
              # proxy_set_header X-Real-IP $remote_addr;
              # proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
              # proxy_set_header X-Forwarded-Proto $scheme;
              # proxy_set_header X-Forwarded-Protocol $scheme;
              # proxy_set_header X-Forwarded-Host $http_host;

              # Disable buffering when the nginx proxy gets very resource heavy upon streaming
              proxy_buffering off;
            '';
          };
          "= /web/" = {
            proxyPass = "http://192.168.0.10:8096/web/index.html";
            extraConfig = ''
              proxy_set_header Host $host;
              proxy_ssl_server_name on;
              # proxy_set_header X-Real-IP $remote_addr;
              # proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
              # proxy_set_header X-Forwarded-Proto $scheme;
              # proxy_set_header X-Forwarded-Protocol $scheme;
              # proxy_set_header X-Forwarded-Host $http_host;
            '';
          };
          "/socket" = {
            proxyPass = "http://192.168.0.10:8096";
            extraConfig = ''
              proxy_http_version 1.1;
              proxy_set_header Upgrade $http_upgrade;
              proxy_set_header Connection "upgrade";
              proxy_set_header Host $host;
              # proxy_set_header X-Real-IP $remote_addr;
              # proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
              # proxy_set_header X-Forwarded-Proto $scheme;
              # proxy_set_header X-Forwarded-Protocol $scheme;
              # proxy_set_header X-Forwarded-Host $http_host;
            '';
          };
        };
      };
    };
  };
}
