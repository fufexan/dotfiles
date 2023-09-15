{
  runCommandLocal,
  matugen,
  wallpaper,
}:
runCommandLocal "theme.json" {} ''
  ${matugen}/bin/matugen image ${wallpaper} --json strip > $out
''
