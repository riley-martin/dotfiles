{ ... }: {
  services.gonic = {
    enable = true;
    settings = {
      music-path = "";
      podcast-path = "";
      playlists-path = "";
    };
  };
  services.nginx.virtualHosts."music.rileymartin.dev" = {
    enableACME = true;
    forceSSL = true;
    locations."/" = {
      proxyPass = "http://localhost:4747/";
    };
  };
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;
  };
}
