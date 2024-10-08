{ ... }:

let
  immichRoot = "/mnt/media/immich"; # TODO: Tweak these to your desired storage locations
  immichPhotos = "${immichRoot}/photos";

in {

  services.immich = {
    enable = true;
    mediaLocation = "${immichPhotos}";
    port = 2283;
    host = "100.106.82.60";
  };
}
