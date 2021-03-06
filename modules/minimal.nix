{ config, pkgs, ... }:

# minimal config, suitable for servers

{
  imports = [ ./shell-environment.nix ];

  programs.direnv = {
    enable = true;
    enableNixDirenvIntegration = true;
    enableZshIntegration = true;
  };
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
    defaultCommand = "rg --files --hidden";
    changeDirWidgetOptions =
      [ "--preview 'tree -C -L 3 -a {} | head -200'" "--exact" ];
  };
  programs.gh = {
    enable = true;
    gitProtocol = "ssh";
  };
  programs.git = {
    enable = true;
    ignores = [ "*~" "*.swp" ];
    signing = {
      key = "3AC82B48170331D3";
      signByDefault = true;
    };
    userEmail = "fufexan@pm.me";
    userName = "Mihai Fufezan";
  };
  programs.gpg = {
    enable = true;
    settings = { homedir = "~/.local/share/gnupg"; };
  };
  programs.neovim = {
    enable = true;
    plugins = with pkgs.vimPlugins; [
      coc-nvim
      coc-pairs
      coc-highlight
      vim-nix
      vimsence
    ];
    extraConfig = builtins.readFile ../config/init.vim;
    vimAlias = true;
    vimdiffAlias = true;
    withNodeJs = true;
  };
  programs.password-store = {
    enable = true;
    package = pkgs.pass.withExtensions (exts: [ exts.pass-otp ]);
    settings = { PASSWORD_STORE_DIR = "$HOME/.local/share/password-store"; };
  };
  services.lorri.enable = true;
}
