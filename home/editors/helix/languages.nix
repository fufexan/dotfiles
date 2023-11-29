{
  pkgs,
  lib,
  ...
}: {
  programs.helix.languages = {
    language = let
      deno = lang: {
        command = "${pkgs.deno}/bin/deno";
        args = ["fmt" "-" "--ext" lang];
      };

      prettier = lang: {
        command = "${pkgs.nodePackages.prettier}/bin/prettier";
        args = ["--parser" lang];
      };
      prettierLangs = map (e: {
        name = e;
        formatter = prettier e;
      });
      langs = ["css" "scss" "html"];
    in
      [
        {
          name = "bash";
          auto-format = true;
          formatter = {
            command = "${pkgs.shfmt}/bin/shfmt";
            args = ["-i" "2"];
          };
        }
        {
          name = "clojure";
          injection-regex = "(clojure|clj|edn|boot|yuck)";
          file-types = ["clj" "cljs" "cljc" "clje" "cljr" "cljx" "edn" "boot" "yuck"];
        }
        {
          name = "javascript";
          auto-format = true;
          language-servers = [
            "eslint"
            "typescript-language-server"
          ];
          formatter = deno "js";
        }
        {
          name = "json";
          formatter = deno "json";
        }
        {
          name = "markdown";
          auto-format = true;
          formatter = deno "md";
        }
      ]
      ++ prettierLangs langs;

    language-server = {
      bash-language-server = {
        command = "${pkgs.nodePackages.bash-language-server}/bin/bash-language-server";
        args = ["start"];
      };

      clangd = {
        command = "${pkgs.clang-tools}/bin/clangd";
        clangd.fallbackFlags = ["-std=c++2b"];
      };

      eslint = {
        command = "${pkgs.nodePackages.eslint}/bin/eslint";
        args = ["--stdin"];
      };

      nil = {
        command = lib.getExe pkgs.nil;
        config.nil.formatting.command = ["${lib.getExe pkgs.alejandra}" "-q"];
      };

      typescript-language-server = {
        command = "${pkgs.nodePackages.typescript-language-server}/bin/typescript-language-server";
        args = ["--stdio"];
      };

      vscode-css-language-server = {
        command = "${pkgs.nodePackages.vscode-css-languageserver-bin}/bin/css-languageserver";
        args = ["--stdio"];
        config = {
          provideFormatter = true;
          css.validate.enable = true;
        };
      };
    };
  };
}
