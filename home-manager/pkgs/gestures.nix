{ pkgs, lib, rustPlatform }:
rustPlatform.buildRustPackage rec {
  pname = "gestures";
  version = "0.6.0";
  src = pkgs.fetchFromGitHub {
    owner = "riley-martin";
    repo = "gestures";
    rev = "443bd6426e4547b702f25571bd8d660a3ed1fae5";
    sha256 = "nudiArJnHpQo4iAEf7vsmxLKSewowp9lBp3wul/XJEA=";
  };

  nativeBuildInputs = [ pkgs.pkgconfig ];
  buildInputs = [ pkgs.libinput ];

  checkPhase = "";
  cargoSha256 = "sha256-kN9dlFxKqHFXAyTreGKNFsfpIqobd4FS+4Ux4AJQ7iM=";
  # cargoLock.lockFile = ./Cargo.lock;

  meta = with lib; {
    description = "Fast touchpad gesture program";
    homepage = "https://github.com/riley-martin/gestures";
    license = licenses.mit;
    platforms = platforms.all;
  };
}