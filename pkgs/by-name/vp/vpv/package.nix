{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  libGL,
  libpng,
  libtiff,
  libjpeg,
  libX11,
  SDL2,
  gdal,
  octave,
  rustPlatform,
  cargo,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "vpv";
  version = "0.8.2";

  src = fetchFromGitHub {
    owner = "kidanger";
    repo = "vpv";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-mlBceYMfsAE7MI6J7xnkJHBJ8RInePooXH5YW9I47YM=";
  };

  cargoRoot = "src/fuzzy-finder";
  cargoDeps = rustPlatform.fetchCargoVendor {
    src = finalAttrs.src;
    sourceRoot = "${finalAttrs.src.name}/src/fuzzy-finder";
    hash = "sha256-5QjKvndExImVn+w6OZNSD5n7K3C+tmN2jJOcDCVEW8I=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    rustPlatform.cargoSetupHook
    cargo
  ];

  buildInputs = [
    libGL
    libpng
    libtiff
    libjpeg
    libX11
    SDL2
    gdal
    octave
  ];

  cmakeFlags = [
    "-DUSE_GDAL=ON"
    "-DUSE_OCTAVE=ON"
    "-DVPV_VERSION=v${finalAttrs.version}"
    "-DBUILD_TESTING=ON"
  ];

  meta = {
    homepage = "https://github.com/kidanger/vpv";
    description = "Image viewer for image processing experts";
    maintainers = [ lib.maintainers.kidanger ];
    license = lib.licenses.gpl3;
    broken = stdenv.hostPlatform.isDarwin; # the CMake expects the SDL2::SDL2main target for darwin
    mainProgram = "vpv";
  };
})
