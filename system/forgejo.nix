{ config, ... }: {
  services.forgejo = {
    enable = true;
    settings = {
      server.DOMAIN = "git.rileymartin.dev";
      server.HTTP_PORT = 7654;
      server.ROOT_URL = "https://git.rileymartin.dev";
      mailer = {
        SMTP_PORT = 587;
        SMTP_ADDR = "mail.rileymartin.dev";
        ENABLED = true;
        USER = "git@rileymartin.dev";
      };
    };
    mailerPasswordFile = config.age.secrets.mailserver.path;
  };
  services.nginx.enable = true;
  services.nginx.virtualHosts."git.rileymartin.dev" = {
    enableACME = true;
    forceSSL = true;
    locations."/" = {
      proxyPass = "http://localhost:7654";
    };
  };
}
