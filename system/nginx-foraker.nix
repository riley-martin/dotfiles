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
      
      "office.rileymartin.dev" = {
        forceSSL = true;
        enableACME = true;
        locations = {
          # static files
          "^~ /browser" = {
            proxyPass = "http://100.106.82.60:9980";
            extraConfig = ''
              proxy_set_header Host $host;
            '';
          };
          # WOPI discovery URL
          "^~ /hosting/discovery" = {
            proxyPass = "http://100.106.82.60:9980";
            extraConfig = ''
              proxy_set_header Host $host;
            '';
          };

          # Capabilities
          "^~ /hosting/capabilities" = {
            proxyPass = "http://100.106.82.60:9980";
            extraConfig = ''
              proxy_set_header Host $host;
            '';
          };

          "~ ^/cool/(.*)/ws$" = {
             proxyPass = "http://100.106.82.60:9980";
             extraConfig = ''
               proxy_set_header Upgrade $http_upgrade;
               proxy_set_header Connection "Upgrade";
               proxy_set_header Host $host;
               proxy_read_timeout 36000s;
            '';
           };

          "~ ^/(c|l)ool" = {
            proxyPass = "http://100.106.82.60:9980";
            extraConfig = ''
              proxy_set_header Upgrade $http_upgrade;
              proxy_set_header Connection "Upgrade";
              proxy_set_header Host $host;
              proxy_read_timeout 36000s;
            '';
          };

          # Admin Console websocket
          "^~ /cool/adminws" = {
            proxyPass = "http://100.106.82.60:9980";
            extraConfig = ''
              proxy_set_header Upgrade $http_upgrade;
              proxy_set_header Connection "Upgrade";
              proxy_set_header Host $host;
              proxy_read_timeout 36000s;
            '';
          };
        };
      };

      "media.rileymartin.dev" = {
        enableACME = true;
        forceSSL = true;
        # clientMaxBodySize = "20M";
        locations = {
          "/".proxyPass = "http://100.106.82.60:8096";
        };
      };

      "music.rileymartin.dev" = {
        enableACME = true;
        forceSSL = true;
        locations."/" = {
          proxyPass = "http://100.106.82.60:4747/";
        };
      };

      "books.rileymartin.dev" = {
        enableACME = true;
        forceSSL = true;
        locations."/" = {
          proxyPass = "http://100.106.82.60:4061";
          proxyWebsockets = true;
        };
      };
      
      "images.rileymartin.dev" = {
        extraConfig = ''
          ## Per https://immich.app/docs/administration/reverse-proxy...
          client_max_body_size 50000M;
        '';
        forceSSL = true;
        enableACME = true;
        locations."/" = {
          proxyPass = "http://100.106.82.60:2283";
          proxyWebsockets = true;
        };
      };

      
      "memos.rileymartin.dev" = {
        extraConfig = ''
          client_max_body_size 50000M;
        '';
        forceSSL = true;
        enableACME = true;
        locations."/" = {
          proxyPass = "http://100.106.82.60:5230";
          proxyWebsockets = true;
        };
      };

      
      "papers.rileymartin.dev" = {
        forceSSL = true;
        enableACME = true;
        locations."/".proxyPass = "http://100.106.82.60:28981";
      };


      "llm.rileymartin.dev" = {
        forceSSL = true;
        enableACME = true;
        locations."/".proxyPass = "http://100.106.82.60:8080";
      };

      
      "git.rileymartin.dev" = {
        enableACME = true;
        forceSSL = true;
        locations."/" = {
          proxyPass = "http://100.106.82.60:7654";
        };
      };

      
      "syncv3.rileymartin.dev" = {
        enableACME = true;
        forceSSL = true;
        locations."/".proxyPass = "http://100.106.82.60:8009";
      };

      "rileymartin.dev" = let
        clientConfig."m.homeserver".base_url = "rileymartin.dev";
        serverConfig."m.server" = "matrix.rileymartin.dev:443";
        syncv3Config."org.matrix.msc3575.proxy".url = "https://syncv3.rileymartin.dev";
        mkWellKnown = data: ''
          default_type application/json;
          add_header Access-Control-Allow-Origin *;
          return 200 '${builtins.toJSON data}';
        '';
      in {
        enableACME = true;
        forceSSL = true;
        # This section is not needed if the server_name of matrix-synapse is equal to
        # the domain (i.e. example.org from @foo:example.org) and the federation port
        # is 8448.
        # Further reference can be found in the docs about delegation under
        # https://element-hq.github.io/synapse/latest/delegate.html
        locations."= /.well-known/matrix/server".extraConfig = mkWellKnown serverConfig;
        # This is usually needed for homeserver discovery (from e.g. other Matrix clients).
        # Further reference can be found in the upstream docs at
        # https://spec.matrix.org/latest/client-server-api/#getwell-knownmatrixclient
        locations."= /.well-known/matrix/client".extraConfig = mkWellKnown (clientConfig // syncv3Config);
      };
      "matrix.rileymartin.dev" = {
        enableACME = true;
        forceSSL = true;
        # It's also possible to do a redirect here or something else, this vhost is not
        # needed for Matrix. It's recommended though to *not put* element
        # here, see also the section about Element.
        locations."/".extraConfig = ''
          return 404;
        '';
        # Forward all Matrix API calls to the synapse Matrix homeserver. A trailing slash
        # *must not* be used here.
        locations."/_matrix".proxyPass = "http://100.106.82.60:8008";
        # Forward requests for e.g. SSO and password-resets.
        locations."/_synapse/client".proxyPass = "http://100.106.82.60:8008";
      };

    };
  };
}
