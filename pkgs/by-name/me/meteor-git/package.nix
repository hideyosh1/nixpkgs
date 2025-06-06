{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:

buildGoModule rec {
  pname = "meteor-git";
  version = "0.27.0";

  src = fetchFromGitHub {
    owner = "stefanlogue";
    repo = "meteor";
    rev = "v${version}";
    hash = "sha256-OH4WQNSbTMaysaHoKcy3S9V7BWu93Djr8toWtQ7Xj/w=";
  };

  vendorHash = "sha256-jKd/eJwp5SZvTrP3RN7xT7ibAB0PQondGR3RT+HQXIo=";

  meta = {
    description = "CLI tool for writing conventional commits";
    mainProgram = "meteor";
    homepage = "https://github.com/stefanlogue/meteor";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ nebunebu ];
  };
}
