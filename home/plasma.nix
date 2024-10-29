{ pkgs, lib, ... }: {
  services.xserver.enable = true;
  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.wayland.enable = true;
  services.desktopManager.plasma6.enable = true;
  programs.kdeconnect.enable = true;
  programs.kdeconnect.package = lib.mkForce pkgs.kdePackages.kdeconnect-kde;
  environment.systemPackages = with pkgs; [ gnome-settings-daemon kdePackages.kcalc ];
}
