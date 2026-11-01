{
  pkgs,
  inputs,
  ...
}:
{
  home.packages = with pkgs; [
    # archives
    zip
    unzip
    unrar

    # misc
    chafa
    libnotify
    sshfs

    # utils
    dust
    duf
    fd
    file
    jaq
    ripgrep
    ripdrag

    # nix
    inputs.tack.packages.${pkgs.stdenv.hostPlatform.system}.tack
  ];

  home.sessionVariables."TACK_NIX_CONF_TOKENS" = "1";

  programs = {
    eza.enable = true;

    ssh = {
      enable = true;
      enableDefaultConfig = false;

      settings = {
        # default ssh config
        "*" = {
          addKeysToAgent = "no";
          certificateFile = [ ];
          checkHostIP = true;
          compression = false;
          controlMaster = "no";
          controlPath = "~/.ssh/master-%r@%n:%p";
          controlPersist = "no";
          dynamicForwards = [ ];
          extraOptions = { };
          forwardAgent = false;
          forwardX11 = false;
          forwardX11Trusted = false;
          hashKnownHosts = false;
          identitiesOnly = false;
          identityAgent = [ ];
          identityFile = [ ];
          localForwards = [ ];
          remoteForwards = [ ];
          sendEnv = [ ];
          serverAliveCountMax = 3;
          serverAliveInterval = 0;
          setEnv = { };
          userKnownHostsFile = "~/.ssh/known_hosts";
        };
      };
    };
  };
}
