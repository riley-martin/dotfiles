{ pkgs ? import <nixpkgs> {}, ... }:
pkgs.stdenv.mkDerivation rec {
  name = "gimp-devel";
  src = pkgs.fetchFromGitHub {
    owner = "GNOME";
    repo = "gimp";
    rev = "50a028ac33f5b7dfc079791b15f91f1e62021c27";
    sha256 = "LkOPyUSqtPEr9JVnWTy/mZ0iKIAVdIiBrKEUmW9md1k=";
  };
  nativeBuildInputs = with pkgs; [ perl autoreconfHook pkgconfig gettext ];
  buildInputs = with pkgs; [
    python3
    luajit_2_1
    gjs
    appstream-glib
    glib-networking
    glib
    mypaint-brushes1
    libarchive
    poppler_gi
    poppler_data
    shared-mime-info
    libwebp
    libheif
    libavif
    lcms2
    vala
    glib
    # gobject
    gobject-introspection
    gtk3
    gexiv2
    cairo
    pango
    # liblcms
    libmypaint
    babl
    gegl
    librsvg
    libpng
    libwmf
    libtiff
    libjpeg
    libjxl
  ];
  enableParallelBuilding = true;
  preConfigure = ''
    export GIO_EXTRA_MODULES="${pkgs.glib-networking}/lib/gio/modules:$GIO_EXTRA_MODULES"
  '';
  configurePhase = "./autogen.sh";
  buildPhase = "make && make install";
  installPhase = ''
    mkdir $out/

    # ln -s ${pkgs.ungoogled-chromium}/bin $out/bin

    mkdir $out/share
    ln -s ${pkgs.ungoogled-chromium}/share/icons $out/share/icons
    ln -s ${pkgs.ungoogled-chromium}/share/man $out/share/man
    ln -s ${pkgs.ungoogled-chromium}/share/applications $out/share/applications

    mkdir $out/bin/

    sed -E 's#(exec)\W("/nix/store/.*/chromium")#cat "$HOME/.config/chromium-flags.conf" | xargs \2#g' \
      ${pkgs.ungoogled-chromium}/bin/chromium \
      > $out/bin/chromium

    chmod +x $out/bin/chromium
  '';
}
