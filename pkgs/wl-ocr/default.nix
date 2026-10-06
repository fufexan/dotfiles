{
  writeShellScriptBin,
  lib,
  grim,
  libnotify,
  slurp,
  tesseract5,
  wl-clipboard,
  langs ? "eng+hun+fra+jpn+jpn_vert+kor+kor_vert+pol+ron+spa",
}:
let
  inherit (lib) getExe getExe';
  # wl-clipboard ships two binaries, so getExe' (not getExe) for each
  wl-copy = getExe' wl-clipboard "wl-copy";
  wl-paste = getExe' wl-clipboard "wl-paste";
in
writeShellScriptBin "wl-ocr" ''
  ${getExe grim} -g "$(${getExe slurp})" -t ppm - | ${getExe tesseract5} -l ${langs} - - | ${wl-copy}
  echo "$(${wl-paste})"
  ${getExe libnotify} -- "$(${wl-paste})"
''
