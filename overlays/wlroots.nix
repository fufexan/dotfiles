{ fetchFromGithub, wlroots }:

wlroots.overrideAttrs (old: {
  src = fetchFromGithub {
    owner = "danvd";
    repo = "wlroots-eglstreams";
    rev = "5e570dc6f5d5d4c9f65c21c3994d0b9ab14e9752";
    sha256 = "0frgd9kqps40qj10bd6sim813v0kwsfy046ja53kbzash3pp78pq";
  };
})
