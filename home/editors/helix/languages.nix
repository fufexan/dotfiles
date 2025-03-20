{
  pkgs,
  lib,
  ...
}: {
  programs.helix.languages = {
    language = let
      deno = lang: {
        command = lib.getExe pkgs.deno;
        args = ["fmt" "-" "--ext" lang];
      };

      prettier = lang: {
        command = lib.getExe pkgs.nodePackages.prettier;
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
            command = lib.getExe pkgs.shfmt;
            args = ["-i" "2"];
          };
        }
        {
          name = "clojure";
          injection-regex = "(clojure|clj|edn|boot|yuck)";
          file-types = ["clj" "cljs" "cljc" "clje" "cljr" "cljx" "edn" "boot" "yuck"];
        }
        {
          name = "cmake";
          auto-format = true;
          language-servers = ["cmake-language-server"];
          formatter = {
            command = lib.getExe pkgs.cmake-format;
            args = ["-"];
          };
        }
        {
          name = "javascript";
          auto-format = true;
          language-servers = ["dprint" "typescript-language-server"];
        }
        {
          name = "json";
          formatter = deno "json";
        }
        {
          name = "markdown";
          language-servers = ["dprint" "markdown-oxide"];
        }
        {
          name = "python";
          auto-format = true;
          language-servers = [
            "basedpyright"
            "ruff"
          ];
        }
        {
          name = "qml";
          language-servers = ["qmlls"];
        }
        {
          name = "typescript";
          auto-format = true;
          language-servers = ["dprint" "typescript-language-server"];
        }
        {
          name = "typst";
          auto-format = true;
          language-servers = ["tinymist"];
        }
      ]
      ++ prettierLangs langs;

    language-server = {
      basedpyright.command = "${pkgs.basedpyright}/bin/basedpyright-langserver";

      bash-language-server = {
        command = lib.getExe pkgs.bash-language-server;
        args = ["start"];
      };

      clangd = {
        command = "${pkgs.clang-tools}/bin/clangd";
        clangd.fallbackFlags = ["-std=c++2b"];
      };

      cmake-language-server = {
        command = lib.getExe pkgs.cmake-language-server;
      };

      deno-lsp = {
        command = lib.getExe pkgs.deno;
        args = ["lsp"];
        environment.NO_COLOR = "1";
        config.deno = {
          enable = true;
          lint = true;
          unstable = true;
          suggest = {
            completeFunctionCalls = false;
            imports = {hosts."https://deno.land" = true;};
          };
          inlayHints = {
            enumMemberValues.enabled = true;
            functionLikeReturnTypes.enabled = true;
            parameterNames.enabled = "all";
            parameterTypes.enabled = true;
            propertyDeclarationTypes.enabled = true;
            variableTypes.enabled = true;
          };
        };
      };

      dprint = {
        command = lib.getExe pkgs.dprint;
        args = ["lsp"];
      };

      nil = {
        command = lib.getExe pkgs.nil;
        config.nil.formatting.command = ["${lib.getExe pkgs.alejandra}" "-q"];
      };

      qmlls = {
        command = "${pkgs.qt6.qtdeclarative}/bin/qmlls";
        args = ["-E"];
      };

      tinymist = {
        command = lib.getExe pkgs.tinymist;
        config = {
          exportPdf = "onType";
          outputPath = "$root/target/$dir/$name";
          formatterMode = "typstyle";
          formatterPrintWidth = 80;
        };
      };

      typescript-language-server = {
        command = lib.getExe pkgs.nodePackages.typescript-language-server;
        args = ["--stdio"];
        config = {
          typescript-language-server.source = {
            addMissingImports.ts = true;
            fixAll.ts = true;
            organizeImports.ts = true;
            removeUnusedImports.ts = true;
            sortImports.ts = true;
          };
        };
      };

      ruff = {
        command = lib.getExe pkgs.ruff;
        args = ["server"];
      };

      vscode-css-language-server = {
        command = "${pkgs.nodePackages.vscode-langservers-extracted}/bin/vscode-css-languageserver";
        args = ["--stdio"];
        config = {
          provideFormatter = true;
          css.validate.enable = true;
          scss.validate.enable = true;
        };
      };
    };
  };

  home.file.".dprint.json".source = builtins.toFile "dprint.json" (builtins.toJSON {
    lineWidth = 80;

    # This applies to both JavaScript & TypeScript
    typescript = {
      quoteStyle = "preferSingle";
      binaryExpression.operatorPosition = "sameLine";
    };

    json.indentWidth = 2;

    excludes = [
      "**/*-lock.json"
    ];

    plugins = [
      "https://plugins.dprint.dev/typescript-0.93.0.wasm"
      "https://plugins.dprint.dev/json-0.19.3.wasm"
      "https://plugins.dprint.dev/markdown-0.17.8.wasm"
    ];
  });
}
