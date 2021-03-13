{ fetchFromGitHub, wlroots, wlroots-src, ... }:

wlroots.overrideAttrs (old: {
  src = wlroots-src;
  buildInputs = old.buildInputs ++ [ uuid ]
   
})
