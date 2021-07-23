{ config, lib, ... }:

let
  starshipSubst = x: lib.mapAttrs' (name: value: { value = builtins.replaceStrings [ "$HOME" ] [ config.home.homeDirectory ] name; name = value; }) x;
in
{
  programs.starship = {
    enable = true;
    settings = {
      add_newline = false;
      character = {
        success_symbol = "[›](bold green)";
        error_symbol = "[›](bold red)";
        vicmd_symbol = "[‹](bold green)";
      };
      cmd_duration.show_notifications = true;
      format = lib.concatStrings [
        "$directory"

        "$git_branch"
        "$git_status"
        "$git_state"

        "$nix_shell"
        "$nodejs"
        "$rust"

        "$cmd_duration"

        "$character"
      ];
      nix_shell.symbol = " ";
      scan_timeout = 10;
    };
  };
}
