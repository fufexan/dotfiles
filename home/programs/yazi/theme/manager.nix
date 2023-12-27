{
  programs.yazi.theme.manager = {
    cwd = {fg = "cyan";};

    # Hovered
    hovered = {
      fg = "black";
      bg = "lightblue";
    };

    preview_hovered = {
      fg = "black";
      bg = "lightblue";
    };

    # Find
    find_keyword = {
      fg = "yellow";
      italic = true;
    };
    find_position = {
      fg = "magenta";
      bg = "reset";
      italic = true;
    };

    # Marker
    marker_selected = {
      fg = "lightgreen";
      # bg = "lightgreen";
    };
    marker_copied = {
      fg = "lightyellow";
      # bg = "lightyellow";
    };
    marker_cut = {
      fg = "lightred";
      # bg = "lightred";
    };

    # Tab
    tab_active = {
      fg = "black";
      bg = "lightblue";
    };
    tab_inactive = {
      fg = "white";
      bg = "darkgray";
    };
    tab_width = 1;

    # Border;
    border_symbol = "│";
    border_style = {fg = "gray";};

    # Offset;
    folder_offset = [1 0 1 0];
    preview_offset = [1 1 1 1];

    # Highlighting;
    syntect_theme = "";
  };
}
