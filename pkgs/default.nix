# Custom packages, that can be defined similarly to ones from nixpkgs
# You can build them using 'nix build .#example' or (legacy) 'nix-build -A example'

{ pkgs ? (import ../nixpkgs.nix) { } }: {
  # example = pkgs.callPackage ./example { };
  gimp-devel = pkgs.callPackage ./gimp-devel {};
  chromium-flagfile = pkgs.callPackage ./chromium-flagfile.nix {};
  fprint-eh575 = pkgs.callPackage ./fprint-eh575.nix {};
  fprintd = pkgs.callPackage ./fprintd.nix {};
  odoo = pkgs.callPackage ./odoo.nix {};
}
