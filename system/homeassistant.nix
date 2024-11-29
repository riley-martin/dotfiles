{ ... }: {
  # services.home-assistant = {
  #   enable = true;
  #   config = {
  #     http.use_x_forwarded_for = true;
  #     http.trusted_proxies = ["100.64.26.109" "fd7a:115c:a1e0::4601:523c"];
  #   };
  #   extraComponents = [
  #     "google" "google_assistant" "google_assistant_sdk"
  #     "mobile_app"
  #     "default_config" "met" "esphome" "shopping_list"
  #   ];
  # };
  virtualisation.oci-containers = {
    backend = "docker";
    containers.homeassistant = {
      volumes = [ "home-assistant:/config" ];
      environment.TZ = "America/New_York";
      image = "ghcr.io/home-assistant/home-assistant:stable"; # Warning: if the tag does not change, the image will not be updated
      extraOptions = [ 
        "--network=host" 
        # "--device=/dev/ttyACM0:/dev/ttyACM0"  # Example, change this to match your own hardware
      ];
    };
  };
}
