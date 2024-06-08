{ ... }: {
  services.ollama = {
    enable = true;
    acceleration = "rocm";
    listenAddress = "0.0.0.0:11434";
    environmentVariables = {
      HSA_OVERRIDE_GFX_VERSION = "9.0.0";
    };
  };

  virtualisation.oci-containers = {
    backend = "docker";
    containers."open-webui" = {
      image = "ghcr.io/open-webui/open-webui:main";

      environment = {
        "TZ" = "America/NewYork";
        "OLLAMA_API_BASE_URL" = "http://127.0.0.1:11434/api";
        "OLLAMA_BASE_URL" = "http://127.0.0.1:11434";
      };

      volumes = [
        "/mnt/media/open-webui/data:/app/backend/data"
      ];

      ports = [
        "127.0.0.1:9876:8080" # Ensures we listen only on localhost
      ];

      extraOptions = [
        "--pull=always" # Pull if the image on the registry is newer
        "--name=open-webui"
        "--hostname=open-webui"
        "--network=host"
        # "--add-host=host.containers.internal:host-gateway"
      ];
    };
  };
  services.nginx = {
    enable = true;
    virtualHosts."llm.rileymartin.dev" = {
      forceSSL = true;
      enableACME = true;
      locations."/".proxyPass = "http://localhost:9876";
    };
  };
}
