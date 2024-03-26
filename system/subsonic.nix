{ ... }: {
  services.gonic = {
    enable = true;
    settings = {
      music-path = "";
      podcast-path = "";
      playlists-path = "";
      cache-path = "/home/subsonic";
    };
  };
  services.nginx.virtualHosts."music.rileymartin.dev" = {
    enableACME = true;
    forceSSL = true;
    locations."/" = {
      proxyPass = "http://localhost:4747/";
    };
  };
}
