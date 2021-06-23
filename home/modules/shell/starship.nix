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
        success_symbol = "[➜](bold green)";
        error_symbol = "[➜](bold red)";
      };
      cmd_duration.show_notifications = true;
      directory = {
        style = "bold purple";
        # doesn't work yet 🤔
        substitutions = starshipSubst config.programs.zsh.dirHashes;
      };
      format = lib.concatStrings [
        "$directory"

        "$git_branch"
        "$git_status"
        "$git_state"

        "$nix_shell"
        "$nodejs"
        "$rust"

        "$cmd_duration"
        "$line_break"

        "$character"
      ];
      nix_shell.symbol = " ";
      scan_timeout = 10;
    };
  };
}
