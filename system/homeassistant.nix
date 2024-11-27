{ ... }: {
  services.home-assistant = {
    enable = true;
    config = {
      http.use_x_forwarded_for = true;
      trusted_proxies = ["100.106.82.60" "fd7a:115c:a1e0::4601:523c"];
    };
  };
}
