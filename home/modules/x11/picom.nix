{ config, pkgs, ... }:

{
  services.picom = {
    enable = true;
    package = pkgs.picom-jonaburg;

    blur = true;
    blurExclude = [
      "class_g = 'slop'"
      "class_g = 'Firefox'"
    ];
    experimentalBackends = true;

    extraOptions = ''
      # Animations
      # requires https://github.com/jonaburg/picom
      #transition-length = 100
      transition-pow-x = 1.4 #0.2
      transition-pow-y = 1.4 #0.2
      transition-pow-w = 1.4 #0.2
      transition-pow-h = 1.4 #0.2
      size-transition = true


      # Corners
      # requires: https://github.com/sdhand/compton or https://github.com/jonaburg/picom
      corner-radius = 10.0;
      rounded-corners-exclude = [
        "class_g = 'Polybar'",
        "class_g = 'Steam'",
        "_PICOM_ROUNDED:32c = 1",
      ];
      round-borders = 1;
      round-borders-exclude = [
        #"class_g = 'TelegramDesktop'",
      ];

      fading = true;
      fade-delta = 5

      # Specify a list of conditions of windows that should not be faded.
      # don't need this, we disable fading for all normal windows with wintypes: {}
      fade-exclude = [
        "class_g = 'slop'" # maim
      ]

      # improve performance
      glx-no-rebind-pixmap = true;

      glx-no-stencil = true;

      # fastest swap method
      glx-swap-method = 1;

      # dual kawase blur
      blur-background-fixed = false;
      blur-method = "dual_kawase";
      blur-strength = 10;

      use-ewmh-active-win = true;
      detect-rounded-corners = true;

      # stop compositing if there's a fullscreen program
      unredir-if-possible = true;

      # group wintypes and don't focus a menu (Telegram)
      detect-transient = true;
      detect-client-leader = true;

      # needed for nvidia with glx backend
      xrender-sync-fence = true;
    '';
  };
}

