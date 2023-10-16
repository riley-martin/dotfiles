{ pkgs, lib, rustPlatform, installShellFiles, makeWrapper }:

rustPlatform.buildRustPackage rec {
  pname = "helix";
  version = "23.03";

  # This release tarball includes source code for the tree-sitter grammars,
  # which is not ordinarily part of the repository.
  src = pkgs.fetchFromGitHub {
    owner = "helix-editor";
    repo = "helix";
    rev = "3cf037237f1d080fdcb7990250955701389ae072";
    sha256 = "Qrn3mB6bb1DSvKxOJ9oAlxuMk64Fzg2W4BVmk6y3deA=";
  };

  cargoSha256 = "sha256-+KnBQA7gYLu2O/5vbY5cdEj9hni0Cn3cWPYswBi4934=";

  nativeBuildInputs = [ installShellFiles makeWrapper ];

  postInstall = ''
    # not needed at runtime
    rm -r runtime/grammars/sources

    mkdir -p $out/lib
    cp -r runtime $out/lib
    installShellCompletion contrib/completion/hx.{bash,fish,zsh}
    mkdir -p $out/share/{applications,icons/hicolor/256x256/apps}
    cp contrib/Helix.desktop $out/share/applications
    cp contrib/helix.png $out/share/icons/hicolor/256x256/apps
    $out/bin/hx --grammar fetch
    $out/bin/hx --grammar build
  '';
  postFixup = ''
    wrapProgram $out/bin/hx --set HELIX_RUNTIME $out/lib/runtime
  '';

  meta = with lib; {
    description = "A post-modern modal text editor";
    homepage = "https://helix-editor.com";
    license = licenses.mpl20;
    mainProgram = "hx";
    maintainers = with maintainers; [ danth yusdacra ];
  };
}
