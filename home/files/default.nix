# manage files in ~

{
  home.file = {
    ".wl-session".source = ./wl-session;

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
