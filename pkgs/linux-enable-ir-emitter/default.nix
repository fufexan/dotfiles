{
  stdenv,
  lib,
  fetchFromGitHub,
  fetchurl,
  bzip2,
  opencv,
  pkg-config,
  python3,
}: let
  pythonInUse =
    python3.withPackages
    (p: [p.face_recognition (p.opencv4.override {enableGtk3 = true;})]);
in
  stdenv.mkDerivation rec {
    pname = "linux-enable-ir-emitter";
    version = "4.1.5+date=2022-10-06";

    src = fetchFromGitHub {
      owner = "EmixamPP";
      repo = pname;
      rev = "1473002f161daca9b2a6dcc1b98e2cfdd28aa73e";
      sha256 = "sha256-qltpqlE7LNN0Qmm14t+qPA7RmQ8Zw2WNCAIzg59/nN8=";
    };

    buildInputs = [pythonInUse opencv pkg-config];

    patches = [./remove-boot-set.patch];

    buildPhase = ''
      make -C sources/driver
    '';

    installPhase = ''
      install -Dm 644 sources/*.py -t $out/lib/linux-enable-ir-emitter/ -v
      install -Dm 644 sources/command/*.py -t $out/lib/linux-enable-ir-emitter/command/ -v
      install -Dm 755 sources/driver/driver-generator -t $out/lib/linux-enable-ir-emitter/driver/ -v
      install -Dm 755 sources/driver/execute-driver -t $out/lib/linux-enable-ir-emitter/driver/ -v

      # executable
      chmod 755 $out/lib/linux-enable-ir-emitter/linux-enable-ir-emitter.py
      mkdir -p $out/bin
      ln -s $out/lib/linux-enable-ir-emitter/linux-enable-ir-emitter.py $out/bin/linux-enable-ir-emitter

      # auto complete for bash
      install -Dm 644 sources/autocomplete/linux-enable-ir-emitter -t $out/share/bash-completion/completions/
    '';
  }
