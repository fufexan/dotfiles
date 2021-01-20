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
        xkeyboardconfig_colemak_dh = super.xorg.xkeyboardconfig.overrideAttrs (old: {
          patches = [
            (builtins.toFile "xkeyboardconfig.patch" ''
              diff -ruN a/rules/evdev.xml b/rules/evdev.xml
              --- a/rules/evdev.xml	2020-10-07 02:24:26.000000000 +0300
              +++ b/rules/evdev.xml	2021-01-17 16:50:54.805730608 +0200
              @@ -1404,6 +1404,12 @@
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
              @@ -4746,6 +4752,12 @@
                         </configItem>
                       </variant>
                       <variant>
              +          <configItem>
              +            <name>colemak_dh</name>
              +            <description>Romanian (Colemak Mod-DH)</description>
              +          </configItem>
              +        </variant>
              +        <variant>
                         <configItem>
                           <name>std</name>
                           <description>Romanian (standard)</description>
              diff -ruN a/symbols/ro b/symbols/ro
              --- a/symbols/ro	2020-10-07 02:24:08.000000000 +0300
              +++ b/symbols/ro	2021-01-17 16:45:31.643856377 +0200
              @@ -74,6 +74,28 @@
               };
              
               partial alphanumeric_keys
              +xkb_symbols "colemak_dh" {
              +    // Add Colemak Mod-DH to Romanian layout
              +
              +    include "ro(basic)"
              +    include "us(colemak_dh)"
              +    name[Group1]= "Romanian (Colemak Mod-DH)"
              +
              +    key <AD01> { [ q, Q, acircumflex, Acircumflex ] };
              +    key <AD02> { [ w, W, ssharp, any ] };
              +    key <AD04> { [ p, P, section, any ] };
              +    key <AD07> { [ l, L, lstroke, Lstroke ] };
              +    key <AD10> { [ semicolon, colon, dead_diaeresis, ellipsis ] };
              +
              +    key <AC01> { [ a, A, abreve, Abreve ] };
              +    key <AC03> { [ s, S, 0x1000219, 0x1000218 ] };
              +    key <AC04> { [ t, T, 0x100021b, 0x100021a ] };
              +    key <AC09> { [ i, I, icircumflex, Icircumflex ] };
              +
              +    key <AB04> { [ d, D, dstroke, Dstroke ] };
              +};
              +
              +partial alphanumeric_keys
               xkb_symbols "std" {
                   // Primary layout in the new Romanian standard.
                   // Implemented here as a variant because of the lack of hardware
              diff -ruN a/symbols/us b/symbols/us
              --- a/symbols/us	2020-10-07 02:24:08.000000000 +0300
              +++ b/symbols/us	2021-01-17 16:44:18.165631942 +0200
              @@ -1454,6 +1454,29 @@
                   include "level3(ralt_switch)"
               };
              
              +// fufexan's <fufexan@protonmail.com> personal implementation of Colemak Mod-DH
              +// Took inspiration and help from:
              +//  https://github.com/DreymaR/BigBagKbdTrixXKB
              +//  https://colemak.academy
              +
              +partial alphanumeric_keys
              +xkb_symbols "colemak_dh" {
              +
              +    include "us(colemak)"
              +    include "level3(ralt_switch)"
              +    name[Group1]= "English (Colemak Mod-DH)";
              +
              +    key <AD05> { [ b, B, enfilledcirclebullet, Greek_beta ] };
              +
              +    key <AC05> { [ g, G, eng, ENG ] };
              +    key <AC06> { [ k, K, ccedilla, Ccedilla ] };
              +
              +    key <AB04> { [ d, D, eth, ETH ] };
              +    key <AB05> { [ v, V, division, Greek_gamma ] };
              +    key <AB06> { [ m, M, multiply, downarrow ] };
              +    key <AB07> { [ h, H, hstroke, Hstroke] };
              +};
              +
               // Carpalx layout created by Martin Krzywinski
               // http://mkweb.bcgsc.ca/carpalx/
               // Merged with us(intl) and us(altgr-intl) and modified to move
            '')
          ];
        });

        xorgserver = super.xorg.xorgserver.overrideAttrs (old: {
          configureFlags = old.configureFlags ++ [
            "--with-xkb-bin-directory=${xkbcomp}/bin"
            "--with-xkb-path=${xkeyboardconfig_colemak_dh}/share/X11/xkb"
          ];
        });

        setxkbmap = super.xorg.setxkbmap.overrideAttrs (old: {
          postInstall =
            ''
              mkdir -p $out/share
              ln -sfn ${xkeyboardconfig_colemak_dh}/etc/X11 $out/share/X11
            '';
        });

        xkbcomp = super.xorg.xkbcomp.overrideAttrs (old: {
          configureFlags = "--with-xkb-config-root=${xkeyboardconfig_colemak_dh}/share/X11/xkb";
        });

      }; # xorg

      xkbvalidate = super.xkbvalidate.override {
        libxkbcommon = super.libxkbcommon.override {
          xkeyboard_config = xorg.xkeyboardconfig_colemak_dh;
        };
      };
    }; # packageOverrides
  };

  # configure X
  services.xserver = {
    enable = true;

    # keyboard config
    layout = "ro";
    #xkbVariant = "colemak_dh";
    xkbOptions = "caps:escape";

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
