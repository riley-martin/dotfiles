{ stdenv
, lib
, fetchurl
, pkg-config
, meson
, atkmm
, alsa-lib
, perl538
, appstream
, babl
, libgudev
, isocodes
, cairo
, gdk-pixbuf
, gegl
, gexiv2
, gtk3
, lcms
, libmypaint
, mypaint-brushes1
, librsvg
, glib-networking
, glib
, desktop-file-utils
, gcc
, appstream-glib
, libarchive
, xorg
, libbacktrace
, ghostscript
, findutils
, coreutils
, bashInteractive
, libmng
, aalib
, openexr
, libwebp
, libheif
, vala
, poppler
, poppler_data
, libwmf
, libjxl
, gjs
, luajit
, libxml2
, libxslt
, gi-docgen
, xvfb-run
, shared-mime-info
, gobject-introspection
, ninja
, python3
, wrapGAppsHook
, gsettings_desktop_schemas
, gnome3
, hicolor-icon-theme
, graphviz
}:

let
  python = python3.withPackages (pp: [ pp.pygobject3 ]);
  lua = luajit.withPackages (ps: [ ps.lgi ]);
in stdenv.mkDerivation (finalAttrs: {
  pname = "gimp";
  version = "2.99.14";

  outputs = [ "out" "dev" ];

  src = fetchurl {
    url = "http://download.gimp.org/pub/gimp/v${lib.versions.majorMinor finalAttrs.version}/gimp-${finalAttrs.version}.tar.xz";
    sha256 = "MTogVHXR/wPFxNlgLwn1yXW6bBx52IQ+I5b5/iq996g=";
    # sha256 = "6b4496edee447339f923276755247eadb64ec40d8aec241d06b62d1a6eb6508d";

  };

  patches = [
    ./babl-0.1-name-change-meson.patch
    ./meson-gtls.patch
    ./pygimp-interp.patch
  ];

  nativeBuildInputs = [
    pkg-config
    libxslt
    ghostscript
    libarchive
    bashInteractive
    libheif
    libwebp
    libmng
    aalib
    libjxl
    isocodes
    perl538
    appstream
    meson
    xvfb-run
    gi-docgen
    findutils
    vala
    alsa-lib
    ninja
    wrapGAppsHook
  ];

  buildInputs = [
    gjs
    lua
    babl
    appstream-glib
    gegl
    gtk3
    glib
    gdk-pixbuf
    cairo
    gexiv2
    lcms
    libjxl
    poppler
    poppler_data
    openexr
    libmng
    librsvg
    desktop-file-utils
    libwmf
    ghostscript
    aalib
    shared-mime-info
    libwebp
    libheif
    xorg.libXpm
    xorg.libXmu
    glib-networking
    libmypaint
    mypaint-brushes1
    gobject-introspection
    python
    libgudev
    gnome3.adwaita-icon-theme
  ];

  preConfigure = "
    patchShebangs tools/gimp-mkenums app/tests/create_test_env.sh
  ";

  preFixup = ''
    gappsWrapperArgs+=(--prefix PATH : "${lib.makeBinPath [
      # for dot for gegl:introspect (Debug » Show Image Graph, hidden by default on stable release)
      graphviz
    ]}:$out/bin")
    gappsWrapperArgs+=(--prefix XDG_DATA_DIRS : "${hicolor-icon-theme}/share:${gnome3.adwaita-icon-theme}/share")
  '';

  enableParallelBuilding = true;

  doCheck = false;

  meta = with lib; {
    description = "The GNU Image Manipulation Program: Development Edition";
    homepage = "https://www.gimp.org/";
    maintainers = with maintainers; [ 9p4 ];
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
    mainProgram = "gimp";
  };
})
