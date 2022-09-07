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
    name = "nix";
    language-server = {command = "${inputs.nil.packages.${pkgs.system}.default}/bin/nil";};
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
]
