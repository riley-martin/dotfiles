{ config, ... }: {
  services.nginx = {
    enable = true;
    virtualHosts."freshrss" = {
      listen = [{
        addr = "100.106.82.60";
        port = 3579;
      }];
    };
  };

  services.freshrss = {
    enable = true;
    virtualHost = "freshrss";
    baseUrl = "https://feed.rileymartin.dev";
    defaultUser = "riley";
    passwordFile = config.age.secrets.freshrss.path;
  };
}
