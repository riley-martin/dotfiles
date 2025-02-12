{ ... }: {
  services.esphome = {
    enable = true;
    address = "0.0.0.0";
    port = 9998;
  };
}
