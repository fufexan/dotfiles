{
  pkgs,
  inputs,
  ...
}:
with pkgs; [
  {
    language-server = {command = "${clang-tools}/bin/clangd";};
    name = "c";
    auto-format = true;
  }
  {
    language-server = {command = "${clang-tools}/bin/clangd";};
    name = "cpp";
    auto-format = true;
  }
  {
    language-server = {command = "${inputs.rnix-lsp.defaultPackage.${pkgs.system}}/bin/rnix-lsp";};
    name = "nix";
  }
  {
    language-server = {command = "${haskell-language-server}/bin/haskell-language-server-wrapper";};
    name = "haskell";
  }
]
