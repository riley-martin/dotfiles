{ ... }:
let
  version = "0.21.0";
in {
  services.nginx.virtualHosts."memos.rileymartin.dev" = {
    extraConfig = ''
      client_max_body_size 50000M;
    '';
    forceSSL = true;
    enableACME = true;
    locations."/" = {
      proxyPass = "http://127.0.0.1:5230";
      proxyWebsockets = true;
    };
  };

  virtualisation.oci-containers.backend = "docker";
  virtualisation.oci-containers.containers.memos = {
    image = "neosmemo/memos:${version}";
    ports = ["127.0.0.1:5230:5230"];
    extraOptions = [
      "--pull=always"
    ];
    volumes = [
      "/home/memos:/var/opt/memos"
    ];
  };
  
}
