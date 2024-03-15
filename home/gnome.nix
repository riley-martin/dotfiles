{ pkgs, ... }: {
  services.xserver.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  environment.gnome.excludePackages = (with pkgs.gnome; [
    atomix
    hitori
    iagno
    tali
  ]);
  environment.systemPackages = (
    ( with pkgs; [ gnome.gnome-tweaks libgtop ] )
    // ( with pkgs.gnomeExtensions; [ tophat window-gestures] )
  );
}
