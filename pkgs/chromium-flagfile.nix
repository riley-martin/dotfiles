{pkgs ? import <nixpkgs> {}, ...}:
let
  chromium = pkgs.chromium;
in pkgs.stdenv.mkDerivation rec {
  name = "chromium-flagfile";
  src = ./.;
  # buildInputs = with pkgs; [ makeWrapper ungoogled-chromium ];
  nativeBuildInputs = with pkgs; [
    ninja
    pkg-config
    python3
    perl
    which
    llvmPackages.bintools
    bison
    gperf
    libevdev
  ];
  buildInputs = [ pkgs.makeWrapper chromium ];
  buildPhase = "true";
  installPhase = ''
    mkdir $out/

    # ln -s ${pkgs.ungoogled-chromium}/bin $out/bin

    mkdir $out/share
    ln -s ${chromium}/share/icons $out/share/icons
    ln -s ${chromium}/share/man $out/share/man
    ln -s ${chromium}/share/applications $out/share/applications

    mkdir $out/bin/

    # Every time I use regex, I remember how much I hate them.
    sed -E 's#(exec)\W("/nix/store/.*/chromium")#cat "$HOME/.config/chromium-flags.conf" | xargs \2#g' \
      ${chromium}/bin/chromium \
      > $out/bin/chromium

    chmod +x $out/bin/chromium
  '';
}
