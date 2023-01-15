{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  util-linux,
}:
stdenvNoCC.mkDerivation {
  pname = "material-symbols";
  version = "unstable-2023-01-07";

  src = fetchFromGitHub {
    owner = "google";
    repo = "material-design-icons";
    rev = "511eea577b20d2b02ad77477750da1e44c66a52c";
    sha256 = "sha256-ENoWeyV9Dw26pgjy0Xst+qpxJ/mjgfqrY2Du2VwzwCE=";
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
