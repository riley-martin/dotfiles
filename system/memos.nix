{ ... }:
let
  version = "0.21.0";
in {
  virtualisation.oci-containers.backend = "docker";
  virtualisation.oci-containers.containers.memos = {
    image = "neosmemo/memos:${version}";
    ports = ["100.106.82.60:5230:5230"];
    extraOptions = [
      "--pull=always"
    ];
    volumes = [
      "/home/memos:/var/opt/memos"
    ];
  };
  
}
