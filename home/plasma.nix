{ pkgs, ... }: {
  services.xserver.enable = true;
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma6.enable = true;
  programs.kdeconnect.enable = true;
  programs.kdeconnect.package = pkgs.kdePackages.kdeconnect-kde;
}
