{ ... }: {
  services.audiobookshelf = {
    enable = true;
    openFirewall = true;
    port = 4061;
  };
  services.nginx.virtualHosts."books.rileymartin.dev" = {
    enableACME = true;
    forceSSL = true;
    locations."/".proxyPass = "http://127.0.0.1:4061";
  };
}
