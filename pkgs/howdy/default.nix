{
  stdenv,
  lib,
  bzip2,
  fetchFromGitHub,
  fetchurl,
  fmt,
  gettext,
  inih,
  installShellFiles,
  libevdev,
  meson,
  ninja,
  pam,
  pkg-config,
  python3,
} @ args: let
  data = import ./sources.nix args;
in
  stdenv.mkDerivation {
    pname = "howdy";
    version = "unstable-2022-04-18";
    inherit (data) src;

    # fix paths
    patches = [./howdy.patch];

    postPatch = ''
      substituteInPlace howdy/src/cli/config.py --replace '/bin/nano' 'nano'
      substituteInPlace "howdy/src/pam/main.cc" \
        --replace "python3" "${data.py}/bin/python" \
        --replace "/lib/security/howdy/compare.py" "$out/lib/security/howdy/compare.py"
    '';

    nativeBuildInputs = [bzip2 installShellFiles meson ninja pkg-config];
    buildInputs = [data.py fmt gettext inih libevdev pam];

    # build howdy_pam
    preConfigure = ''
      cd howdy/src/pam
      export DESTDIR=$out
    '';

    postInstall = let
      libDir = "$out/lib/security/howdy";
      inherit (lib) mapAttrsToList concatStrings;
    in ''
      # done with howdy_pam, go back to source root
      cd ../../../..

      mkdir -p $out/share/licenses/howdy
      install -Dm644 LICENSE $out/share/licenses/howdy/LICENSE
      mkdir -p ${libDir}
      cp -r howdy/src/* ${libDir}

      rm -rf ${libDir}/pam-config ${libDir}/dlib-data/*
      ${concatStrings (mapAttrsToList (n: v: ''
          bzip2 -dc ${v} > ${libDir}/dlib-data/${n}
        '')
        data.data)}

      mkdir -p $out/bin
      ln -s ${libDir}/cli.py $out/bin/howdy

      mkdir -p "$out/share/bash-completion/completions"
      installShellCompletion --bash howdy/src/autocomplete/howdy
    '';

    meta = {
      description = "Windows Hello™ style facial authentication for Linux";
      homepage = "https://github.com/boltgolt/howdy";
      license = lib.licenses.mit;
      platforms = lib.platforms.linux;
      maintainers = with lib.maintainers; [fufexan];
    };
  }
