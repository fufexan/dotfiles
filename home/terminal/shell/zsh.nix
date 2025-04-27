{
  config,
  lib,
  ...
}: {
  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    autocd = true;
    dirHashes = {
      dl = "$HOME/Downloads";
      docs = "$HOME/Documents";
      code = "$HOME/Documents/code";
      dots = "$HOME/Documents/code/dotfiles";
      pics = "$HOME/Pictures";
      vids = "$HOME/Videos";
      nixpkgs = "$HOME/Documents/code/git/nixpkgs";
    };
    dotDir = ".config/zsh";
    history = {
      expireDuplicatesFirst = true;
      path = "${config.xdg.dataHome}/zsh_history";
    };

    initContent = ''
      # search history based on what's typed in the prompt
      autoload -U history-search-end
      zle -N history-beginning-search-backward-end history-search-end
      zle -N history-beginning-search-forward-end history-search-end
      bindkey "^[OA" history-beginning-search-backward-end
      bindkey "^[OB" history-beginning-search-forward-end

      # C-right / C-left for word skips
      bindkey "^[[1;5C" forward-word
      bindkey "^[[1;5D" backward-word

      # C-Backspace / C-Delete for word deletions
      bindkey "^[[3;5~" forward-kill-word
      bindkey "^H" backward-kill-word

      # Home/End
      bindkey "^[[OH" beginning-of-line
      bindkey "^[[OF" end-of-line

      # open commands in $EDITOR with C-e
      autoload -z edit-command-line
      zle -N edit-command-line
      bindkey "^e" edit-command-line

      # case insensitive tab completion
      zstyle ':completion:*' completer _complete _ignored _approximate
      zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
      zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
      zstyle ':completion:*' menu select
      zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
      zstyle ':completion:*' verbose true

      # use cache for completions
      zstyle ':completion:*' use-cache on
      zstyle ':completion:*' cache-path "$XDG_CACHE_HOME/zsh/.zcompcache"
      _comp_options+=(globdots)

      # Allow foot to pipe command output
      function precmd {
          if ! builtin zle; then
              print -n "\e]133;D\e\\"
          fi
      }

      function preexec {
          print -n "\e]133;C\e\\"
      }

      ${lib.optionalString config.services.gpg-agent.enable ''
        gnupg_path=$(ls $XDG_RUNTIME_DIR/gnupg)
        export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/gnupg/$gnupg_path/S.gpg-agent.ssh"
      ''}
    '';

    shellAliases =
      {
        g = "git";
        grep = "grep --color";
        ip = "ip --color";
        l = "eza -l";
        la = "eza -la";
        md = "mkdir -p";
        ppc = "powerprofilesctl";
        pf = "powerprofilesctl launch -p performance";

        us = "systemctl --user"; # mnemonic for user systemctl
        rs = "sudo systemctl"; # mnemonic for root systemctl
      }
      // lib.optionalAttrs config.programs.bat.enable {cat = "bat";};
    shellGlobalAliases = {eza = "eza --icons --git";};
  };
}
