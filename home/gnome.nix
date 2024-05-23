{ pkgs, inputs, ... }:
let
  packages = with pkgs; [ gnome.gnome-tweaks gnome.gnome-settings-daemon gjs ];
  extensions = with pkgs.gnomeExtensions; [ inputs.update-ddterm.legacyPackages.x86_64-linux.gnomeExtensions.ddterm tophat window-gestures appindicator astra-monitor gsconnect pop-shell ];
in
{
  # this enables dynamic triple buffering
  # see https://nixos.wiki/wiki/GNOME and https://gitlab.gnome.org/GNOME/mutter/-/merge_requests/1441
  # nixpkgs.overlays = [
  #   (final: prev: {
  #       gnome = prev.gnome.overrideScope' (gnomeFinal: gnomePrev: {
  #         mutter = gnomePrev.mutter.overrideAttrs ( old: {
  #           src = pkgs.fetchgit {
  #             url = "https://gitlab.gnome.org/vanvugt/mutter.git";
  #             # GNOME 45: triple-buffering-v4-45
  #             rev = "0b896518b2028d9c4d6ea44806d093fd33793689";
  #             sha256 = "sha256-mzNy5GPlB2qkI2KEAErJQzO//uo8yO0kPQUwvGDwR4w=";
  #           };
  #         } );
  #       });
  #   })
  # ];
  services.xserver.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  services.xserver.desktopManager.gnome.sessionPath = with pkgs; [ libgtop ];
  environment.gnome.excludePackages = (with pkgs.gnome; [
    atomix
    hitori
    iagno
    tali
  ]);
  environment.systemPackages = packages ++ extensions;
}
