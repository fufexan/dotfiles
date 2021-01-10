{ configs, pkgs, ... }:

{
  # install packages specific to X
  environment.systemPackages = with pkgs; [
    # gui utils
    feh maim polybarFull rofi rofi-emoji picom

    # notifications
    dunst

    # cli utils
    xclip xorg.xkill xdotool

    # also install sxhkd for bspwm
    sxhkd
  ];

  # keyboard configuration
  # adds colemak_dh variant to us and ro layouts
  nixpkgs.config = {
    packageOverrides = super: rec {
      xorg = super.xorg // rec {
        xkeyboardconfig_rolf = super.xorg.xkeyboardconfig.overrideAttrs (old: {
          patches = [
            (builtins.toFile "xkeyboardconfig.patch" ''
                diff -ruN xkeyboard-config-2.31.orig/symbols/us xkeyboard-config-2.31/symbols/us
                --- xkeyboard-config-2.31.orig/symbols/us  1970-01-01 02:00:01.000000000 +0200
                +++ xkeyboard-config-2.31/symbols/us  2020-11-26 14:10:28.246176654 +0200
                @@ -802,6 +802,25 @@
                     include "level3(ralt_switch)"
                 };

                +// fufexan's <fufexan@protonmail.com> personal implementation of Colemak Mod-DH
                +// Took inspiration and help from:
                +//  https://github.com/DreymaR/BigBagKbdTrixXKB
                +//  https://colemak.academy
                +
                +partial alphanumeric_keys
                +xkb_symbols "colemak_dh" {
                +    include "us(colemak)"
                +    include "level3(ralt_switch)"
                +
                +    key <AD05> { [ b, B, enfilledcirclebullet, Greek_beta ] };
                +    key <AC05> { [ g, G, eng, ENG ] };
                +    key <AC06> { [ k, K, ccedilla, Ccedilla ] };
                +    key <AB04> { [ d, D, eth, ETH ] };
                +    key <AB05> { [ v, V, division, Greek_gamma ] };
                +    key <AB06> { [ m, M, multiply, downarrow ] };
                +    key <AB07> { [ h, H, hstroke, Hstroke] };
                +};
                +
                 // I do NOT like dead-keys - the International keyboard as defined by Microsoft
                 // does not fit my needs. Why use two keystrokes for all simple characters (eg '
                 // and <space> generates a single ') just to have an é (eacute) in two strokes
                diff -ruN xkeyboard-config-2.31.orig/symbols/ro xkeyboard-config-2.31/symbols/ro
                --- xkeyboard-config-2.31.orig/symbols/ro  1970-01-01 02:00:01.000000000 +0200
                +++ xkeyboard-config-2.31/symbols/ro  2020-11-26 14:09:46.605019130 +0200
                @@ -73,6 +73,24 @@
                     key <AC02> { [ s,                      S,  scedilla,   Scedilla ] };
                 };

                +// Add Colemak Mod-DH to Romanian layout
                +partial alphanumeric_keys
                +xkb_symbols "colemak_dh" {
                +    include "ro(basic)"
                +    include "us(colemak_dh)"
                +
                +    key <AD01> { [ q, Q, acircumflex, Acircumflex ] };
                +    key <AD02> { [ w, W, ssharp, any ] };
                +    key <AD04> { [ p, P, section, any ] };
                +    key <AD07> { [ l, L, lstroke, Lstroke ] };
                +    key <AC01> { [ a, A, abreve, Abreve ] };
                +    key <AC03> { [ s, S, 0x1000219, 0x1000218 ] };
                +    key <AC04> { [ t, T, 0x100021b, 0x100021a ] };
                +    key <AC09> { [ i, I, icircumflex, Icircumflex ] };
                +    key <AB04> { [ d, D, dstroke, Dstroke ] };
                +    key <AD10> { [ semicolon, colon, dead_diaeresis, ellipsis ] };
                +};
                +
                 partial alphanumeric_keys
                 xkb_symbols "std" {
                     // Primary layout in the new Romanian standard.
                diff -ruN xkeyboard-config-2.31.orig/rules/evdev.xml xkeyboard-config-2.31/rules/evdev.xml
                --- xkeyboard-config-2.31.orig/rules/evdev.xml  1970-01-01 02:00:01.000000000 +0200
                +++ xkeyboard-config-2.31/rules/evdev.xml  2020-11-26 14:07:55.703602154 +0200
                @@ -1400,10 +1400,16 @@
                           <configItem>
                             <name>colemak</name>
                             <description>English (Colemak)</description>
                -          </configItem>
                +          </configItem>  
                         </variant>
                         <variant>
                           <configItem>
                +            <name>colemak_dh</name>
                +            <description>English (Colemak Mod-DH)</description>
                +          </configItem>
                +        </variant>
                +        <variant>
                +          <configItem>
                             <name>dvorak</name>
                             <description>English (Dvorak)</description>
                           </configItem>
                @@ -4747,6 +4753,12 @@
                         </variant>
                         <variant>
                           <configItem>
                +            <name>colemak_dh</name>
                +            <description>Romanian (Colemak Mod-DH)</description>
                +        </configItem>
                +        </variant>
                +        <variant>
                +          <configItem>
                             <name>std</name>
                             <description>Romanian (standard)</description>
                           </configItem>
            '')
          ];
        });

        xorgserver = super.xorg.xorgserver.overrideAttrs (old: {
          configureFlags = old.configureFlags ++ [
            "--with-xkb-bin-directory=${xkbcomp}/bin"
            "--with-xkb-path=${xkeyboardconfig_rolf}/share/X11/xkb"
          ];
        });

        setxkbmap = super.xorg.setxkbmap.overrideAttrs (old: {
          postInstall =
            ''
              mkdir -p $out/share
              ln -sfn ${xkeyboardconfig_rolf}/etc/X11 $out/share/X11
            '';
        });

        xkbcomp = super.xorg.xkbcomp.overrideAttrs (old: {
          configureFlags = "--with-xkb-config-root=${xkeyboardconfig_rolf}/share/X11/xkb";
        });

      }; # xorg

      xkbvalidate = super.xkbvalidate.override {
        libxkbcommon = super.libxkbcommon.override {
          xkeyboard_config = xorg.xkeyboardconfig_rolf;
        };
      };
    }; # packageOverrides
  };

  # configure X
  services.xserver = {
    enable = true;

    # keyboard config
    layout = "ro"; # same as us, but with a few new letters when using AltGr

    videoDrivers = [ "nvidia" ];

    # display manager setup
    displayManager = {
      defaultSession = "none+bspwm";
    };

    windowManager.bspwm.enable = true;

    # disable mouse acceleration
    libinput = {
      enable = true;
      accelProfile = "flat";
      accelSpeed = "0";
    };
  };
}
