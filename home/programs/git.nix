{pkgs, ...}: {
  home.packages = [pkgs.gh];

  programs.git = {
    enable = true;

    delta = {
      enable = true;
      options.map-styles = "bold purple => syntax #8839ef, bold cyan => syntax #1e66f5";
    };

    extraConfig = {
      diff.colorMoved = "default";
      merge.conflictstyle = "diff3";
    };

    aliases = {
      forgor = "commit --amend --no-edit";
      graph = "log --all --decorate --graph --oneline";
      oops = "checkout --";
    };

    ignores = ["*~" "*.swp" "*result*" ".direnv" "node_modules"];

    signing = {
      key = "5899325F2F120900";
      signByDefault = true;
    };

    userEmail = "fufexan@protonmail.com";
    userName = "Mihai Fufezan";
  };
}
