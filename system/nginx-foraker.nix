{ config, ... }: {
  services.nginx = {
    enable = true;
    logError = "stderr info";

    resolver.addresses = [ "[::1]" "127.0.0.1" "1.1.1.1" "100.100.100.100"];

    # Use recommended settings
    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;

    # Only allow PFS-enabled ciphers with AES256
    sslCiphers = "AES256+EECDH:AES256+EDH:!aNULL";

    # Setup Nextcloud virtual host to listen on ports
    virtualHosts = {

    #   "cloud.rileymartin.xyz" = {
    #     forceSSL = true;
    #     enableACME = true;
    #     locations."/" = {
    #       return = "301 https://cloud.rileymartin.dev";
    #     };
    #   };

      "cloud.rileymartin.dev" = {
        ## Force HTTP redirect to HTTPS
        forceSSL = true;
        ## LetsEncrypt
        enableACME = true;
        locations."/" = {
          proxyPass = "http://100.106.82.60:80/";
          extraConfig = ''
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-Port $server_port;
            proxy_set_header X-Forwarded-Scheme $scheme;
            proxy_set_header X-Forwarded-Proto $scheme;
    
            client_body_buffer_size 512k;
            proxy_read_timeout 86400s;
            client_max_body_size 4G;
            proxy_headers_hash_max_size 8192;
            proxy_headers_hash_bucket_size 256;
          '';
        };
        locations."/.well-known/carddav" = {
          return = "301 https://cloud.rileymartin.dev/remote.php/dav";
        };
        locations."/.well-known/caldav" = {
          return = "301 https://cloud.rileymartin.dev/remote.php/dav";
        };
      };

    #   "warden.rileymartin.xyz" = {
    #     enableACME = true;
    #     forceSSL = true;
    #     locations."/" = {
    #       return = "301 https://warden.rileymartin.dev";
    #     };
    #   };

      "warden.rileymartin.dev" = {
        forceSSL = true;
        enableACME = true;
        locations."/" = {
          proxyPass = "http://100.106.82.60:8222";
        };
      };
      
    #   "office.rileymartin.dev" = {
    #     forceSSL = true;
    #     enableACME = true;
    #     locations = {
    #       # static files
    #       "^~ /browser" = {
    #         proxyPass = "http://localhost:9980";
    #         extraConfig = ''
    #           proxy_set_header Host $host;
    #         '';
    #       };
    #       # WOPI discovery URL
    #       "^~ /hosting/discovery" = {
    #         proxyPass = "http://localhost:9980";
    #         extraConfig = ''
    #           proxy_set_header Host $host;
    #         '';
    #       };

    #       # Capabilities
    #       "^~ /hosting/capabilities" = {
    #         proxyPass = "http://localhost:9980";
    #         extraConfig = ''
    #           proxy_set_header Host $host;
    #         '';
    #       };

    #       "~ ^/cool/(.*)/ws$" = {
    #          proxyPass = "http://127.0.0.1:9980";
    #          extraConfig = ''
    #            proxy_set_header Upgrade $http_upgrade;
    #            proxy_set_header Connection "Upgrade";
    #            proxy_set_header Host $host;
    #            proxy_read_timeout 36000s;
    #         '';
    #        };


    #       # download, presentation, image upload and websocket
    #       # "~ ^/lool" = {
    #       #   proxyPass = "http://localhost:9980";
    #       #   extraConfig = ''
    #       #     proxy_set_header Upgrade $http_upgrade;
    #       #     proxy_set_header Connection "Upgrade";
    #       #     proxy_set_header Host $host;
    #       #     proxy_read_timeout 36000s;
    #       #   '';
    #       # };

    #       "~ ^/(c|l)ool" = {
    #         proxyPass = "http://localhost:9980";
    #         extraConfig = ''
    #           proxy_set_header Upgrade $http_upgrade;
    #           proxy_set_header Connection "Upgrade";
    #           proxy_set_header Host $host;
    #           proxy_read_timeout 36000s;
    #         '';
    #       };

    #       # Admin Console websocket
    #       "^~ /cool/adminws" = {
    #         proxyPass = "http://localhost:9980";
    #         extraConfig = ''
    #           proxy_set_header Upgrade $http_upgrade;
    #           proxy_set_header Connection "Upgrade";
    #           proxy_set_header Host $host;
    #           proxy_read_timeout 36000s;
    #         '';
    #       };
    #     };
    #   };

    #   "media.rileymartin.dev" = {
    #     enableACME = true;
    #     forceSSL = true;
    #     # clientMaxBodySize = "20M";
    #     locations = {
    #       "/".proxyPass = "http://127.0.0.1:8096";
    #     };
    #   };
    };
  };
}
