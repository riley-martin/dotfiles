{ pkgs, lib, stdenv
# , fetchFromGitLab
# , pkg-config
# , meson
# , python3
# , ninja
# , gusb
# , pixman
# , glib
# , nss
# , gobject-introspection
# , coreutils
# , cairo
# , libgudev
# , gtk-doc
# , docbook-xsl-nons
# , docbook_xml_dtd_43
}:

with pkgs;
stdenv.mkDerivation rec {
  pname = "libfprint";
  version = "1.94.5";
  outputs = [ "out" "devdoc" ];

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "topni1";
    repo = pname;
    rev = "2776600bd0de832c5fc3689fbabefe0538a6b904";
    sha256 = "91vOQLwIJ/p+WZgE+NOdPl6L8c97S65SCzWVr7qkt10=";
  };

  postPatch = ''
    patchShebangs \
      tests/test-runner.sh \
      tests/unittest_inspector.py \
      tests/virtual-image.py \
      tests/umockdev-test.py \
      tests/test-generated-hwdb.sh
  '';

  nativeBuildInputs = [
    pkg-config
    meson
    ninja
    gtk-doc
    docbook-xsl-nons
    docbook_xml_dtd_43
    gobject-introspection
  ];

  buildInputs = [
    gusb
    pixman
    glib
    nss
    cairo
    libgudev
  ];

  mesonFlags = [
    "-Dudev_rules_dir=${placeholder "out"}/lib/udev/rules.d"
    # Include virtual drivers for fprintd tests
    "-Ddrivers=all"
    "-Dudev_hwdb_dir=${placeholder "out"}/lib/udev/hwdb.d"
    # "-Dpam_modules_dir=${placeholder "out"}/lib/security"
    "-Dsysconfdir=${placeholder "out"}/etc"
    # "-Ddbus_service_dir=${placeholder "out"}/share/dbus-1/system-services"
    # "-Dsystemd_system_unit_dir=${placeholder "out"}/lib/systemd/system"
  ];

  nativeInstallCheckInputs = [
    (python3.withPackages (p: with p; [ pygobject3 ]))
  ];

  # We need to run tests _after_ install so all the paths that get loaded are in
  # the right place.
  doCheck = false;

  doInstallCheck = true;

  installCheckPhase = ''
    runHook preInstallCheck

    ninjaCheckPhase

    runHook postInstallCheck
  '';

  meta = with lib; {
    homepage = "https://fprint.freedesktop.org/";
    description = "A library designed to make it easy to add support for consumer fingerprint readers";
    license = licenses.lgpl21Only;
    platforms = platforms.linux;
    maintainers = with maintainers; [ abbradar ];
  };
}
