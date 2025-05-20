{
  inputs,
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
    in [
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
        name = "css";
        formatter = prettier "css";
        language-servers = ["vscode-css-language-server" "tailwindcss-ls"];
      }
      {
        name = "javascript";
        auto-format = true;
        language-servers = ["dprint" "typescript-language-server" "uwu-colors"];
      }
      {
        name = "json";
        formatter = deno "json";
      }
      {
        name = "html";
        formatter = prettier "html";
        language-servers = ["vscode-html-language-server" "tailwindcss-ls"];
      }
      {
        name = "markdown";
        language-servers = ["dprint" "markdown-oxide"];
      }
      {
        name = "nix";
        language-servers = ["nil" "uwu-colors"];
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
        language-servers = ["qmlls" "uwu-colors"];
      }
      {
        name = "scss";
        formatter = prettier "scss";
        language-servers = ["vscode-css-language-server" "tailwindcss-ls"];
      }
      {
        name = "typescript";
        auto-format = true;
        language-servers = ["dprint" "typescript-language-server" "uwu-colors"];
      }
      {
        name = "typst";
        auto-format = true;
        language-servers = ["tinymist"];
      }
      {
        name = "vue";
        auto-format = true;
        formatter = prettier "vue";
        language-servers = ["typescript-language-server" "tailwindcss-ls"];
      }
    ];

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

      ruff = {
        command = lib.getExe pkgs.ruff;
        args = ["server"];
      };

      tailwindcss-ls = {
        command = lib.getExe pkgs.tailwindcss-language-server;
        args = ["--stdio"];
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
          plugins = [
            {
              name = "@vue/typescript-plugin";
              location = "${pkgs.vue-language-server}/lib/node_modules/@vue/language-server";
              languages = ["vue"];
            }
          ];
        };
      };

      uwu-colors = {
        command = "${inputs.uwu-colors.packages.${pkgs.system}.default}/bin/uwu_colors";
        # command = "uwu_colors"; # useful for testing
      };

      vscode-css-language-server = {
        command = "${pkgs.nodePackages.vscode-langservers-extracted}/bin/vscode-css-language-server";
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
