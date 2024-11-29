{ ... }: {
  services.home-assistant = {
    enable = true;
    config = {
      http.use_x_forwarded_for = true;
      http.trusted_proxies = ["100.64.26.109" "fd7a:115c:a1e0::4601:523c"];
    };
    extraComponents = [
      "google" "google_assistant" "google_assistant_sdk"
      "mobile_app"
      "default_config" "met" "esphome" "shopping_list"
    ];
  };
}
