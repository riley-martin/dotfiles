{ pkgs, lib, ... }: {
  services.xserver.enable = true;
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.displayManager.sddm.wayland.enable = true;
  services.xserver.desktopManager.plasma6.enable = true;
  programs.kdeconnect.enable = true;
  programs.kdeconnect.package = lib.mkForce pkgs.kdePackages.kdeconnect-kde;
  environment.systemPackages = with pkgs; [ gnome.gnome-settings-daemon ];
}
