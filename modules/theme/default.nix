# this arg is the matugen flake input
matugen: {
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.programs.matugen;

  # used to print valid values of an enum
  printEnum = list: builtins.concatStringsSep ", " (map (x: "`${x}`") list);

  # configFormat = pkgs.formats.toml {};

  # don't use ~, use $HOME
  # sanitizedTemplates =
  #   builtins.mapAttrs (_: v: {
  #     input_path = builtins.toString v.input_path;
  #     output_path = builtins.replaceStrings ["$HOME"] ["~"] v.output_path;
  #   })
  #   cfg.templates;

  # matugenConfig = configFormat.generate "matugen-config.toml" {
  #   config = {};
  #   templates = sanitizedTemplates;
  # };

  # matugenConfig = pkgs.writeText "matugen-config.toml" (builtins.concatStringsSep "\n" generatedTemplates);

  # get matugen package
  pkg = matugen.packages.${pkgs.system}.default;

  themePackage = pkgs.runCommandLocal "matugen-themes-${cfg.variant}" {} ''
    export HOME=$(pwd)
    mkdir -p $out

    ${pkg}/bin/matugen \
      image ${cfg.wallpaper} \
      --mode ${cfg.variant} \
      --palette ${cfg.palette} \
      --json ${cfg.jsonFormat} \
      > $out/theme.json
  '';
  colors = builtins.fromJSON (builtins.readFile "${themePackage}/theme.json");
in {
  options.programs.matugen = {
    enable = lib.mkEnableOption "Matugen declarative theming";

    wallpaper = lib.mkOption {
      description = "Path to `wallpaper` that matugen will generate the colorschemes from";
      type = lib.types.path;
      default = "${pkgs.nixos-artwork.wallpapers.simple-blue}/share/backgrounds/nixos/nix-wallpaper-simple-blue.png";
      defaultText = lib.literalExample ''
        "${pkgs.nixos-artwork.wallpapers.simple-blue}/share/backgrounds/nixos/nix-wallpaper-simple-blue.png"
      '';
    };

    # templates = lib.mkOption {
    #   type = with lib.types;
    #     attrsOf (submodule {
    #       options = {
    #         input_path = lib.mkOption {
    #           type = path;
    #           description = "Path to the template";
    #           example = "./style.css";
    #         };
    #         output_path = lib.mkOption {
    #           type = str;
    #           description = "Path where the generated file will be written to";
    #           example = "~/.config/sytle.css";
    #         };
    #       };
    #     });
    #   description = ''
    #     Templates that have `@{placeholders}` which will be replaced by the respective colors.
    #     See <https://github.com/InioX/Matugen/#example-of-all-the-color-keywords> for a list of colors.
    #   '';
    # };

    palette = let
      validPalettes = ["default" "triadic" "adjacent"];
    in
      lib.mkOption {
        description = "Palette used when generating the colorschemes. Can be one of ${printEnum validPalettes}";
        type = lib.types.enum validPalettes;
        default = "default";
        example = "triadic";
      };

    jsonFormat = let
      validFormats = ["rgb" "rgba" "hsl" "hsla" "hex" "strip"];
    in
      lib.mkOption {
        description = "Color format of the colorschemes. Can be one of ${printEnum validFormats}";
        type = lib.types.enum validFormats;
        default = "strip";
        example = "rgba";
      };

    variant = let
      validVariants = ["light" "dark" "amoled"];
    in
      lib.mkOption {
        description = "Colorscheme variant. Can be one of ${printEnum validVariants}";
        type = lib.types.enum validVariants;
        default = "dark";
        example = "light";
      };

    theme.files = lib.mkOption {
      type = lib.types.package;
      readOnly = true;
      default = themePackage;
      description = "Generated theme files";
    };

    theme.colors = lib.mkOption {
      type = with lib.types; attrsOf anything;
      readOnly = true;
      default = colors;
      description = "Generated theme colors";
    };
  };
}
