{ config, ... }: {
  services.paperless = {
    enable = true;
    passwordFile = config.age.secrets.paperless.path;
    address = "100.106.82.60";
  };
}
