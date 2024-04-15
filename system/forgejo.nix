{ config, ... }: {
  services.forgejo = {
    enable = true;
    settings = {
      server.DOMAIN = "git.rileymartin.dev";
      server.HTTP_PORT = 7654;
    };
    mailerPasswordFile = config.age.secrets.mailserver.path;
  };
  services.nginx.enable = true;
  services.nginx.virtualHosts."git.rileymartin.dev" = {
    locations."/" = {
      proxyPass = "http://localhost:7654";
    };
  };
}
