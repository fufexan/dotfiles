{
  # DEPRECATED
  # this stopped working for reasons unknown to me
  # I have stopped using it, as I can set the layout physically, through my
  # keyboard macro system. I may come back and resolve this in the future

  # Q: What do you mean with "it doesn't work"?
  # A: setxkbmap gives `Error loading new keyboard description` each time it
  # is run, even though it worked before.
  # I have tried finding the cause of this, but all I got was that aside
  # from hash differences, the files in `xkeyboard-config` are exactly the
  # same, and the only thing that changed in `setxkbmap` is the hash name of
  # the xkeyboard-config XKB files location (obviously).
  # I noticed the change happened after I changed the repo owner from
  # fufexan to DreymaR (after he merged my fork). There shouldn't be any
  # difference in behaviour, yet it is.
  # If you want to test for yourself, change owner and repo:
  # previously working: owner = "fufexan"; rev = "872b1891fd3d8b43e1e0fee6a1a0ef6ccda99e49";
  # current, not working: owner = "DreymaR"; rev = "f2dd703c5b66aa9fe5d64b982b7fb5cd45a424de";
  # calculate the sha256 with `nix-prefetch-url`.

  # if you have any more questions, feel free to message me.

  # keyboard configuration
  # configures with Colemak mods that you specify
  # NOTE: it will cause a lot of local builds
  nixpkgs.config.packageOverrides = super: rec {
    # patch xorg with individual packages
    xorg = super.xorg // rec {
      # XKB files' package. the other patches build upon this
      xkeyboardconfig_colemak_mods = super.xorg.xkeyboardconfig.overrideAttrs (old: rec {
        # download DreymaR's Bag of Keyboard Trix
        kbdTricks = pkgs.fetchFromGitHub {
          owner = "DreymaR";
          repo = "BigBagKbdTrixXKB";
          rev = "f2dd703c5b66aa9fe5d64b982b7fb5cd45a424de";
          sha256 = "165n68ry3fyag4p6w03hzsbzpws8x3hqqb5prkvbmx5ds21c5l5c";
        };

        # specify your desired mods
        mods = "4caw ro ks";

        # actual installation of the mods
        postFixup = ''
          bash ${kbdTricks}/install-dreymar-xmod.sh -nsoc $out/etc/X11 ${mods}
        '';
      });
      # now configure the other packages to use the XKB files from the overriden
      # derivation instead of the official one
      setxkbmap = super.xorg.setxkbmap.overrideAttrs (old: {
        postInstall =
          ''
            mkdir -p $out/share
            ln -sfn ${xkeyboardconfig_colemak_mods}/etc/X11 $out/share/X11
          '';
      });
      xkbcomp = super.xorg.xkbcomp.overrideAttrs (old: {
        configureFlags = "--with-xkb-config-root=${xkeyboardconfig_colemak_mods}/share/X11/xkb";
      });
      xorgserver = super.xorg.xorgserver.overrideAttrs (old: {
        configureFlags = old.configureFlags ++ [
          "--with-xkb-bin-directory=${xkbcomp}/bin"
          "--with-xkb-path=${xkeyboardconfig_colemak_mods}/share/X11/xkb"
        ];
      });
    }; # xorg
    # in order for our patches to work, this also needs to be reconfigured
    xkbvalidate = super.xkbvalidate.override {
      libxkbcommon = super.libxkbcommon.override {
        xkeyboard_config = xorg.xkeyboardconfig_colemak_mods;
      };
    };
  }; # packageOverrides

  # second approach to adding DreymaR's mods

  # wanted to add DreymaR's patched xkb files the official way, but it doesn't
  # really work. help is welcome
  #services.xserver = {
  #  extraLayouts = {
  #    colemak = {
  #      description = "DreymaR's Colemak mods";
  #      languages = [ "eng" ];
  #      symbolsFile = ./xkb/symbols/colemak;
  #      typesFile = ./xkb/types/level5;
  #      geometryFile = ./xkb/geometry/pc;
  #      keycodesFile = ./xkb/keycodes/evdev;
  #    };
  #    ro = {
  #      description = "Romanian modded with Colemak";
  #      languages = [ "rum" ];
  #      symbolsFile = ./xkb/symbols/ro;
  #    };
  #  };

  #  layout = "ro";
  #  xkbModel = "pc105aw-sl";
  #  xkbOptions = "misc:cmk_dh";
  #  xkbVariant = "cmk_ed_ks";
  #};
}
