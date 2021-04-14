{ wineUnstable, ... }:

(wineUnstable.overrideAttrs (old: {
  patches = old.patches ++ [
    (builtins.fetchurl {
      url =
        "https://cdn.discordapp.com/attachments/457310786994307073/830469544103116800/winepulse-v6.5-revert-wasapifriendy.patch";
      sha256 = "1wjjwf1jfwafk1kdq0iw0r3hvi1h0i7ni276pv263rkkv418i8bq";
    })
  ];
})).override {
  wineBuild = "wine32";
  pngSupport = true;
  gettextSupport = true;
  fontconfigSupport = true;
  openglSupport = true;
  tlsSupport = true;
  gstreamerSupport = true;
  dbusSupport = true;
  mpg123Support = true;
  cairoSupport = true;
  netapiSupport = true;
  pcapSupport = true;
  saneSupport = true;
  pulseaudioSupport = true;
  udevSupport = true;
  xmlSupport = true;
}
