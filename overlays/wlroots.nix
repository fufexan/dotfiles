final: prev: {
  wlroots = prev.wlroots.overrideAttrs (old: {
    src = {
      owner = "danvd";
      repo = "wlroots-eglstreams";
      rev = master;
      sha256 = "0000000000000000000000000000000000000000000000000000";
    };
  });
}
