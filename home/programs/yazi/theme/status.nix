{
  programs.yazi.theme.status = {
    separator_open = "";
    separator_close = "";
    separator_style = {
      fg = "darkgray";
      bg = "darkgray";
    };

    # Mode;
    mode_normal = {
      fg = "black";
      bg = "lightblue";
      bold = true;
    };
    mode_select = {
      fg = "black";
      bg = "lightgreen";
      bold = true;
    };
    mode_unset = {
      fg = "black";
      bg = "lightmagenta";
      bold = true;
    };

    # Progress;
    progress_label = {bold = true;};
    progress_normal = {
      fg = "blue";
      bg = "black";
    };
    progress_error = {
      fg = "red";
      bg = "black";
    };

    # Permissions;
    permissions_t = {fg = "blue";};
    permissions_r = {fg = "lightyellow";};
    permissions_w = {fg = "lightred";};
    permissions_x = {fg = "lightgreen";};
    permissions_s = {fg = "darkgray";};
  };
}
