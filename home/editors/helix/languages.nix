{pkgs, ...}:
with pkgs; [
  {
    name = "bash";
    language-server = {
      command = "${nodePackages.bash-language-server}/bin/bash-language-server";
      args = ["start"];
    };
    auto-format = true;
    formatter = {
      command = "${shfmt}/bin/shfmt";
      args = ["-i" "2" "-"];
    };
  }
  {
    name = "clojure";
    scope = "source.clojure";
    injection-regex = "(clojure|clj|edn|boot|yuck)";
    file-types = ["clj" "cljs" "cljc" "clje" "cljr" "cljx" "edn" "boot" "yuck"];
    roots = ["project.clj" "build.boot" "deps.edn" "shadow-cljs.edn"];
    comment-token = ";";
    language-server = {command = "clojure-lsp";};
    indent = {
      tab-width = 2;
      unit = "  ";
    };
  }
  {
    name = "cpp";
    language-server = {
      command = "${clang-tools}/bin/clangd";
      clangd.fallbackFlags = ["-std=c++2b"];
    };
  }
  {
    name = "css";
    language-server = {
      command = "${nodePackages.vscode-css-languageserver-bin}/bin/css-languageserver";
      args = ["--stdio"];
    };
  }
  {
    name = "nix";
    language-server.command = lib.getExe nil;
    config.nil.formatting.command = ["alejandra" "-q"];
  }
]
