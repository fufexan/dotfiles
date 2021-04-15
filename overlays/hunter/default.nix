{ lib
, stdenv
, pkg-config
, rustPlatform
, fetchFromGitHub
, IOKit
, makeWrapper
, glib
, gst_all_1
}:

rustPlatform.buildRustPackage rec {
  pname = "hunter";
  version = "1.3.5";

  src = fetchFromGitHub {
    owner = "06kellyjac";
    repo = "hunter";
    rev = "2484f0db580bed1972fd5000e1e949a4082d2f01";
    sha256 = "sha256-oSuwM6cxEw4ybiwoYX6A/aqiU6NVu9cLLONalUHuE1A=";
  };

  RUSTC_BOOTSTRAP = 1;

  nativeBuildInputs = [ makeWrapper pkg-config ];
  buildInputs = [
    glib
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-ugly
    gst_all_1.gst-plugins-bad
  ] ++ lib.optionals stdenv.isDarwin [ IOKit ];

  cargoBuildFlags = [ "--no-default-features" "--features=img,video" ];

  postInstall = ''
    wrapProgram $out/bin/hunter --prefix GST_PLUGIN_SYSTEM_PATH_1_0 : "$GST_PLUGIN_SYSTEM_PATH_1_0"
  '';

  cargoSha256 = "sha256-9DvEuT7Ht0p9vvlQqT/pKL2XuIkJNVAA3KSD+D0Ap38=";

  meta = with lib; {
    description = "The fastest file manager in the galaxy!";
    homepage = "https://github.com/rabite0/hunter";
    license = licenses.wtfpl;
    maintainers = with maintainers; [ fufexan ];
    platforms = platforms.unix;
  };
}
