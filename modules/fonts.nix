{ pkgs, ... }:

{
  fonts = {
    fonts = with pkgs; [
      # icon fonts
      material-design-icons

      # normal fonts
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji
      liberation_ttf_v1

      # bitmap fonts
      gohufont
      tewi-font

      # nerdfonts
      (nerdfonts.override { fonts = [ "FiraCode" "Iosevka" ]; })
    ];

    # use fonts specified by user rather than default ones
    enableDefaultFonts = false;

    # user defined fonts
    # the reason there's Noto Color Emoji everywhere is to override DejaVu's
    # B&W emojis that would sometimes show instead of some Color emojis
    fontconfig.defaultFonts = {
      serif = [ "Noto Serif" "Noto Color Emoji" "DejaVu Serif" ];
      sansSerif = [ "Noto Sans" "Noto Color Emoji" "DejaVu Sans" ];
      monospace = [ "FiraCode Nerd Font" "Noto Color Emoji" "DejaVu Sans Mono" ];
      emoji = [ "Noto Color Emoji" ];
    };
  };
}
