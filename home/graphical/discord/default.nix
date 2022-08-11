{
  pkgs,
  inputs,
  ...
}: {
  home.packages = [inputs.webcord.packages.${pkgs.system}.default];

  programs.discocss = {
    enable = true;
    # discord = pkgs.discord.override {withOpenASAR = true;};
    discord = inputs.self.packages.${pkgs.system}.discord-electron-openasar;
    css = builtins.readFile ./catppuccin-mocha.css;
  };
}
