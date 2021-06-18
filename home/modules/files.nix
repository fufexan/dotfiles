# manage files in ~

{
  home.file = {
    # font for rofi applets
    ".local/share/fonts" = {
      source = ../files/fonts;
      recursive = true;
    };

    # config files
    ".config" = {
      source = ../files/config;
      recursive = true;
    };

    # scripts
    ".local/bin" = {
      source = ../files/bin;
      recursive = true;
    };
  };
}
