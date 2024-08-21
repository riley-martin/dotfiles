{ ... }: {
  services.audiobookshelf = {
    enable = true;
    openFirewall = true;
    port = 4061;
    host = "100.106.82.60";
  };
}
