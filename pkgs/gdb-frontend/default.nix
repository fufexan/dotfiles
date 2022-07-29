{
  lib,
  bash,
  stdenv,
  fetchFromGitHub,
  python3,
  gdb,
  tmux,
}:
stdenv.mkDerivation rec {
  pname = "gdb-frontend";
  version = "0.10.3-beta";

  src = fetchFromGitHub {
    repo = pname;
    owner = "rohanrhu";
    rev = "v${version}";
    sha256 = "sha256-+l1SguRKnLDqT4rgXcod9xhiCOJZEKdZlOZfTNzP7fk=";
  };

  buildInputs = [gdb python3 tmux];
  propagatedUserEnvPkgs = [gdb python3 tmux];

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    mkdir -p $out/bin
    cp -r . $out
    echo "${python3}/bin/python $out/run.py \"\$@\"" > $out/bin/gdbfrontend
    chmod +x $out/bin/gdbfrontend
  '';

  postPatch = ''
    substituteInPlace "run.py" \
      --replace "/bin/bash" "${bash}/bin/bash"
    substituteInPlace "gdbfrontend-window" \
      --replace "/bin/bash" "${bash}/bin/bash"
    substituteInPlace "build_gdb.sh" \
      --replace "/bin/bash\n" "${bash}/bin/bash\n"
    substituteInPlace "url_modules/api/shell.py" \
      --replace "/bin/bash" "${bash}/bin/bash"
    substituteInPlace "commands/gdbfrontend" \
      --replace "/bin/bash" "${bash}/bin/bash"
  '';

  meta = with lib; {
    description = "GDBFrontend is an easy, flexible and extensionable gui debugger";
    homepage = "https://github.com/rohanrhu/gdb-frontend";
    mainProgram = "gdbfrontend";
    platforms = platforms.linux;
    maintainers = with maintainers; [fufexan];
  };
}
