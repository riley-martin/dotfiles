{ config, ... }: {
  services.paperless = {
    enable = true;
    passwordFile = config.age.secrets.paperless.path;
  };
  services.nginx = {
    enable = true;
    virtualHosts."papers.rileymartin.dev" = {
      forceSSL = true;
      enableACME = true;
      locations."/".proxyPass = "http://localhost:28981";
    };
  };
}
