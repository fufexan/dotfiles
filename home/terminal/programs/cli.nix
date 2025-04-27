{
  pkgs,
  config,
  ...
}: {
  home.packages = with pkgs; [
    # archives
    zip
    unzip
    unrar

    # misc
    libnotify
    sshfs

    # utils
    du-dust
    duf
    fd
    file
    jaq
    ripgrep
    ripdrag
  ];

  programs = {
    eza.enable = true;
    ssh = {
      enable = true;

      matchBlocks."cloudut" = {
        hostname = "10.20.7.115";
        user = "cloud7115";
        identityFile = "${config.home.homeDirectory}/.ssh/cloud7115_id_ed25519";
      };
    };
  };
}
