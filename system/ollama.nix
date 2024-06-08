{ ... }: {
  services.ollama = {
    enable = true;
    acceleration = "rocm";
    listenAddress = "0.0.0.0:11434";
    environmentVariables = {
      HSA_OVERRIDE_GFX_VERSION = "9.0.0";
    };
  };
}
