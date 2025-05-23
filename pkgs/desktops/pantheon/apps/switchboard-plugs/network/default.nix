{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
  meson,
  ninja,
  pkg-config,
  replaceVars,
  vala,
  libadwaita,
  libgee,
  gettext,
  granite7,
  gtk4,
  networkmanager,
  networkmanagerapplet,
  libnma-gtk4,
  switchboard,
}:

stdenv.mkDerivation rec {
  pname = "switchboard-plug-network";
  version = "8.1.0";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = pname;
    rev = version;
    hash = "sha256-mTTcavuxnRSBiifFpga14xPReHguvp9wIUS71Djorjk=";
  };

  patches = [
    (replaceVars ./fix-paths.patch {
      inherit networkmanagerapplet;
    })
  ];

  nativeBuildInputs = [
    gettext
    meson
    ninja
    pkg-config
    vala
  ];

  buildInputs = [
    granite7
    gtk4
    libadwaita
    libgee
    networkmanager
    libnma-gtk4
    switchboard
  ];

  strictDeps = true;

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = "Switchboard Networking Plug";
    homepage = "https://github.com/elementary/switchboard-plug-network";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    teams = [ teams.pantheon ];
  };
}
