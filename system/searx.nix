{ config, ... }: {
  services.searx = {
    enable = true;
    environmentFile = config.age.secrets.searx.path;
    settings = {
      server.port = 4321;
      server.bind_address = "100.106.82.60";
      server.secret_key = "@SEARX_SECRET_KEY@";
    };
    redisCreateLocally = true;
  };
}
