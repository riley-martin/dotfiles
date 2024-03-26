{ ... }: {
  services.gonic = {
    enable = true;
    settings = {};
  };
  services.nginx.virtualHosts."music.rileymartin.dev" = {
    enableACME = true;
    forceSSL = true;
    locations."/" = {
      proxyPass = "http://localhost:4747/";
    };
  };
}
