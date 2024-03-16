{ pkgs, ... }:
let
  packages = with pkgs; [ gnome.gnome-tweaks gnome.gnome-settings-daemon ];
  extensions = with pkgs.gnomeExtensions; [ tophat window-gestures appindicator ];
in
{
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
