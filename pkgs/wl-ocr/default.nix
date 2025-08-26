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
  _ = lib.getExe;
in
writeShellScriptBin "wl-ocr" ''
  ${_ grim} -g "$(${_ slurp})" -t ppm - | ${_ tesseract5} -l ${langs} - - | ${wl-clipboard}/bin/wl-copy
  echo "$(${wl-clipboard}/bin/wl-paste)"
  ${_ libnotify} -- "$(${wl-clipboard}/bin/wl-paste)"
''
