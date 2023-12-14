{
  pkgs,
  config,
  ...
}: let
  variant =
    if config.programs.matugen.variant == "light"
    then "latte"
    else "mocha";
in {
  home.packages = with pkgs; [
    # archives
    zip
    unzip
    unrar

    # utils
    du-dust
    duf
    fd
    file
    jaq
    ripgrep

    # file managers
    ranger
  ];

  programs = {
    bat = {
      enable = true;
      config = {
        pager = "less -FR";
        theme = "Catppuccin-${variant}";
      };
      themes = let
        src = pkgs.fetchFromGitHub {
          owner = "catppuccin";
          repo = "bat";
          rev = "ba4d16880d63e656acced2b7d4e034e4a93f74b1";
          hash = "sha256-6WVKQErGdaqb++oaXnY3i6/GuH2FhTgK0v4TN4Y0Wbw=";
        };
      in {
        Catppuccin-mocha = {
          inherit src;
          file = "Catppuccin-mocha.tmTheme";
        };
        Catppuccin-latte = {
          inherit src;
          file = "Catppuccin-latte.tmTheme";
        };
      };
    };

    btop.enable = true;
    eza.enable = true;
    ssh.enable = true;

    skim = {
      enable = true;
      enableZshIntegration = true;
      defaultCommand = "rg --files --hidden";
      changeDirWidgetOptions = [
        "--preview 'eza --icons --git --color always -T -L 3 {} | head -200'"
        "--exact"
      ];
    };
  };
}
