{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  util-linux,
}:
stdenvNoCC.mkDerivation {
  pname = "material-symbols";
  version = "unstable-2022-12-05";

  src = fetchFromGitHub {
    owner = "google";
    repo = "material-design-icons";
    rev = "c764ca99a5f24cfca7f97d98a92b259b92f903da";
    sha256 = "sha256-J45TND4CowFCaEcybFNSI3AgyqdgvzMuTKCozh+gDe0=";
    sparseCheckout = ["variablefont"];
  };

  nativeBuildInputs = [util-linux];

  installPhase = ''
    runHook preInstall

    rename '[FILL,GRAD,opsz,wght]' "" variablefont/*
    install -Dm755 variablefont/*.ttf -t $out/share/fonts/TTF
    install -Dm755 variablefont/*.woff2 -t $out/share/fonts/woff2

    runHook postInstall
  '';

  meta = with lib; {
    description = "Material Symbols icons by Google";
    homepage = "https://fonts.google.com/icons";
    license = lib.licenses.asl20;
    maintainers = with maintainers; [fufexan];
    platforms = platforms.all;
  };
}
