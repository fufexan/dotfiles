# manage files in ~

{
  home.file = {
    ".local/share/fonts" = {
      source = ./fonts;
      recursive = true;
    };

    ".config" = {
      source = ./config;
      recursive = true;
    };

    ".local/bin" = {
      source = ./bin;
      recursive = true;
    };
  };
}
