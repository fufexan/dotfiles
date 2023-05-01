{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:
stdenvNoCC.mkDerivation {
  pname = "catppuccin-plymouth";
  version = "unstable-2022-12-10";

  src = fetchFromGitHub {
    owner = "catppuccin";
    repo = "plymouth";
    rev = "d4105cf336599653783c34c4a2d6ca8c93f9281c";
    hash = "sha256-quBSH8hx3gD7y1JNWAKQdTk3CmO4t1kVo4cOGbeWlNE=";
  };

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/plymouth
    cp -r themes $out/share/plymouth/

    for i in frappe latte macchiato mocha; do
    	cat themes/catppuccin-$i/catppuccin-$i.plymouth | sed "s@\/usr\/@$out\/@" > $out/share/plymouth/themes/catppuccin-$i/catppuccin-$i.plymouth
    done

    runHook postInstall
  '';

  meta = {
    description = "Soothing pastel theme for Plymouth";
    homepage = "https://github.com/catppuccin/plymouth";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [fufexan];
    platforms = lib.platforms.linux;
  };
}
