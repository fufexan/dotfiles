{
  pkgs,
  inputs,
  ...
}: {
  home.packages = with pkgs; [
    ciscoPacketTracer8
    inputs.nix-matlab.packages.${pkgs.system}.matlab
  ];

  xdg.configFile."matlab/nix.sh".text = ''
    INSTALL_DIR=$HOME/.local/share/MATLAB/R2023b
  '';
}
