{
  lib,
  stdenvNoCC,
  fetchurl,
  gzip,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "codeium-language-server";
  version = "1.2.26";

  src = fetchurl {
    url = "https://github.com/Exafunction/codeium/releases/download/language-server-v${finalAttrs.version}/language_server_linux_x64.gz";
    hash = "sha256-bAz/9KiHyIBLg5YFhorrj2bTqeFnKRMF7qfxl8SX3Go=";
  };

  unpackPhase = ''
    runHook preUnpack

    ${gzip}/bin/gunzip -cf $src > codeium
    chmod +x codeium
    pwd
    ls

    runHook postUnpack
  '';

  installPhase = ''
    runHook preInstall

    ls
    mkdir -p $out/bin

    runHook postInstall
  '';

  meta = {
    description = "Codeium Language Server";
    license = lib.licenses.unfree;
    mainProgram = "codeium";
    maintainers = [lib.maintainers.fufexan];
    platforms = [lib.platforms.linux];
  };
})
