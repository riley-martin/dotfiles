{ ... }:

let
  immichRoot = "/home/immich"; # TODO: Tweak these to your desired storage locations
  immichPhotos = "${immichRoot}/photos";
  immichAppdataRoot = "${immichRoot}/appdata";
  immichVersion = "v1.117.0";
  immichExternalVolume1 = "/mnt/media/Videos";
  immichExternalVolume2 = "/mnt/media/Pictures";

in {

  services.immich = {
    enable = true;
    mediaLocation = "${immichPhotos}";
    port = 2283;
    host = "100.106.82.60";
  };
}
