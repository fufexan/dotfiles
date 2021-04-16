{ lib, stdenv, pkg-config, rustPlatform, fetchFromGitLab, capnproto }:

rustPlatform.buildRustPackage rec {
  pname = "shellac-server";
  version = "0.3.1";

  src = fetchFromGitLab {
    domain = "gitlab.redox-os.org";
    owner = "AdminXVII";
    repo = "shellac-server";
    rev = "9b25a28203afdcd60c67bd9424de12c40dfadd3e";
    sha256 = "sha256-TQBqPy1L9/HzELAcHe9zT5ge9KX3df0j8ZKajMohJ44=";
  };

  RUSTC_BOOTSTRAP = 1;

  nativeBuildInputs = [ pkg-config capnproto ];

  cargoSha256 = "sha256-ncGk0/vvTx1IH57XRIbYXgFOUMEe7/LnJYDl3o80wZg=";

  meta = with lib; {
    description = "Early POC for a native, shell-agnostic completion server.";
    homepage = "https://gitlab.redox-os.org/AdminXVII/shellac-server";
    license = licenses.mit;
    maintainers = with maintainers; [ fufexan ];
    platforms = platforms.unix;
  };
}
