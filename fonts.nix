{ configs, pkgs, ... }:

{
  fonts = {
    fonts = with pkgs; [
        # icon fonts
      font-awesome
      material-icons

      # normal fonts
      noto-fonts
      liberation_ttf_v1
      source-han-sans
      source-han-serif

            # bitmap fonts
      gohufont
      siji
      tewi-font

            # nerdfonts
      (nerdfonts.override { fonts = [ "FiraCode" "Mononoki" "Terminus" ]; })
    ];

    enableDefaultFonts = false;

    fontconfig.defaultFonts = {
      serif = [ "Noto Serif" "Noto Color Emoji" "DejaVu Serif" ];
      sansSerif = [ "Noto Sans" "Noto Color Emoji" "DejaVu Sans" ];
      monospace = [ "mononoki Nerd Font" "Noto Color Emoji" "DejaVu Sans Mono" ];
      emoji = [ "Noto Color Emoji" ];
    };
  };
}
