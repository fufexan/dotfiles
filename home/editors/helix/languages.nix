{
  pkgs,
  inputs,
  ...
}:
with pkgs; [
  {
    name = "bash";
    language-server = {
      command = "${nodePackages.bash-language-server}/bin/bash-language-server";
      args = ["start"];
    };
    auto-format = true;
  }
  {
    name = "cpp";
    language-server = {
      command = "${clang-tools}/bin/clangd";
      clangd.fallbackFlags = ["-std=c++2b"];
    };
  }
  {
    name = "nix";
    language-server = {command = lib.getExe inputs.nil.packages.${pkgs.hostPlatform.system}.default;};
    config.nil.formatting.command = ["alejandra" "-q"];
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
    name= "css";
    language-server = {
      command = "${pkgs.nodePackages.vscode-css-languageserver-bin}/bin/css-languageserver";
      args = ["--stdio"];
    };
  }
]
