{
  config,
  pkgs,
  self,
  inputs,
  default,
  ...
}: {
  imports = [./hardware-configuration.nix];

  age.secrets.spotify = {
    file = "${self}/secrets/spotify.age";
    owner = "mihai";
    group = "users";
  };

  boot = {
    binfmt.emulatedSystems = ["aarch64-linux" "riscv64-linux"];

    # use latest kernel
    kernelPackages = pkgs.linuxPackages_latest;

    kernelParams = [
      "amd_pstate=active"
      "quiet"
      "loglevel=3"
      "systemd.show_status=auto"
      "rd.udev.log_level=3"
    ];
  };

  environment.systemPackages = [config.boot.kernelPackages.cpupower];

  networking.hostName = "io";

  programs = {
    # enable hyprland and required options
    hyprland.enable = true;

    matugen = {
      enable = false;

      wallpaper = default.wallpaper;
    };

    steam = {
      enable = true;
      # fix gamescope inside steam
      package = pkgs.steam.override {
        # extraPkgs = pkgs:
        #   with pkgs; [
        #     keyutils
        #     libkrb5
        #     libpng
        #     libpulseaudio
        #     libvorbis
        #     stdenv.cc.cc.lib
        #     xorg.libXcursor
        #     xorg.libXi
        #     xorg.libXinerama
        #     xorg.libXScrnSaver
        #   ];
        # set correct scaling
        extraProfile = "export GDK_SCALE=2";
      };
    };
  };

  security.tpm2.enable = true;

  services = {
    # for SSD/NVME
    fstrim.enable = true;

    howdy = {
      enable = true;
      package = inputs.nixpkgs-howdy.legacyPackages.${pkgs.system}.howdy;
      settings = {
        core.no_confirmation = true;
        video.dark_threshold = 90;
      };
    };
    linux-enable-ir-emitter = {
      enable = true;
      package = inputs.nixpkgs-howdy.legacyPackages.${pkgs.system}.linux-enable-ir-emitter;
    };

    kmonad.keyboards = {
      io = {
        name = "io";
        device = "/dev/input/by-path/platform-i8042-serio-0-event-kbd";
        defcfg = {
          enable = true;
          fallthrough = true;
          allowCommands = false;
        };
        config = builtins.readFile "${self}/modules/main.kbd";
      };
    };
  };
}
