{ pkgs, ... }:
let
  packages = with pkgs; [ gnome-tweaks gjs ptyxis adwaita-qt adwaita-qt6 adwaita-icon-theme adwaita-icon-theme-legacy];
  extensions = with pkgs.gnomeExtensions; [ ddterm window-gestures astra-monitor gsconnect pop-shell ];
in
{

  nixpkgs.overlays = [
    # GNOME 46: triple-buffering-v4-46
    (final: prev: {
      gnome = prev.gnome.overrideScope (gnomeFinal: gnomePrev: {
        mutter = gnomePrev.mutter.overrideAttrs (old: {
          src = pkgs.fetchFromGitLab  {
            domain = "gitlab.gnome.org";
            owner = "vanvugt";
            repo = "mutter";
            rev = "triple-buffering-v4-46";
            hash = "sha256-C2VfW3ThPEZ37YkX7ejlyumLnWa9oij333d5c4yfZxc=";
          };
        });
      });
    })
  ];

  services.xserver.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  services.xserver.desktopManager.gnome.sessionPath = with pkgs; [ libgtop ];
  environment.gnome.excludePackages = (with pkgs.gnome; [
  ]);
  environment.systemPackages = packages ++ extensions;

  qt = {
    enable = true;
    platformTheme = "gnome";
    style = "adwaita-dark";
  };
}
