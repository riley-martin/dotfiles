{ config, ... }: {
  services.paperless = {
    enable = true;
    passwordFile = config.age.secrets.paperless.path;
    address = "100.106.82.60";
    settings.PAPERLESS_CSRF_TRUSTED_ORIGINS = ["https://papers.rileymartin.dev"];
  };
}
