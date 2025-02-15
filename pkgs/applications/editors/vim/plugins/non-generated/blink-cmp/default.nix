{
  lib,
  rustPlatform,
  fetchFromGitHub,
  stdenv,
  vimUtils,
  nix-update-script,
  git,
  replaceVars,
}:
let
  version = "0.9.3";
  src = fetchFromGitHub {
    owner = "Saghen";
    repo = "blink.cmp";
    tag = "v${version}";
    hash = "sha256-j6hBURbIZbvNE69l4AyCtCwfeOi3oNxVtooFK7/WUuA=";
  };
  libExt = if stdenv.hostPlatform.isDarwin then "dylib" else "so";
  blink-fuzzy-lib = rustPlatform.buildRustPackage {
    inherit version src;
    pname = "blink-fuzzy-lib";

    useFetchCargoVendor = true;
    cargoHash = "sha256-ISCrUaIWNn+SfNzrAXKqeBbQyEnuqs3F8GAEl90kK7I=";

    nativeBuildInputs = [ git ];

    env = {
      # TODO: remove this if plugin stops using nightly rust
      RUSTC_BOOTSTRAP = true;
    };
  };
in
vimUtils.buildVimPlugin {
  pname = "blink.cmp";
  inherit version src;
  preInstall = ''
    mkdir -p target/release
    ln -s ${blink-fuzzy-lib}/lib/libblink_cmp_fuzzy.${libExt} target/release/libblink_cmp_fuzzy.${libExt}
  '';

  patches = [
    (replaceVars ./force-version.patch { inherit (src) tag; })
  ];

  passthru = {
    updateScript = nix-update-script {
      attrPath = "vimPlugins.blink-cmp.blink-fuzzy-lib";
    };

    # needed for the update script
    inherit blink-fuzzy-lib;
  };

  meta = {
    description = "Performant, batteries-included completion plugin for Neovim";
    homepage = "https://github.com/saghen/blink.cmp";
    maintainers = with lib.maintainers; [
      balssh
      redxtech
    ];
  };
  doInstallCheck = true;
  nvimRequireCheck = "blink-cmp";
}
