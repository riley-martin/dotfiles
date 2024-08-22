{ config, pkgs, ... }:
let
  domain = "rileymartin.dev";
  fqdn = "matrix.rileymartin.dev";
  baseUrl = "https://${fqdn}";
in {

  services.postgresql = {
    enable = true;
    authentication = pkgs.lib.mkOverride 10 ''
      #type database  DBuser  auth-method
      host    matrix-synapse     matrix-synapse ::1/128     md5
      host matrix-synapse matrix-synapse samehost trust
      local all       all     trust
    '';
  };

  services.matrix-synapse = {
    enable = true;
    settings.server_name = domain;
    extraConfigFiles = [
      config.age.secrets.matrix.path
    ];
    # The public base URL value must match the `base_url` value set in `clientConfig` above.
    # The default value here is based on `server_name`, so if your `server_name` is different
    # from the value of `fqdn` above, you will likely run into some mismatched domain names
    # in client applications.
    settings.public_baseurl = baseUrl;
    settings.listeners = [
      { port = 8008;
        bind_addresses = [ "100.106.82.60" ];
        type = "http";
        tls = false;
        x_forwarded = true;
        resources = [ {
          names = [ "client" "federation" ];
          compress = true;
        } ];
      }
    ];
  };

  services.matrix-sliding-sync = {
    enable = true;
    settings.SYNCV3_SERVER = "https://matrix.rileymartin.dev";
    environmentFile = config.age.secrets.matrix-sliding-sync.path;
  };
}
