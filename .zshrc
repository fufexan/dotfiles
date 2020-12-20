# Lines configured by zsh-newuser-install
HISTFILE=~/.cache/.histfile
HISTSIZE=1000
SAVEHIST=10000
bindkey -v
export KEYTIMEOUT=1
# End of lines configured by zsh-newuser-install

#fpath+=/usr/share/zsh/functions

# Search based on what's already typed in the prompt
autoload -U history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^[[A" history-beginning-search-backward-end
bindkey "^[[B" history-beginning-search-forward-end

# Allow editing command in vim with ^E
autoload edit-command-line
zle -N edit-command-line
bindkey '^e' edit-command-line

# user config

# shell options
#setopt NO_CASE_GLOB
#setopt AUTO_CD
#setopt GLOB_COMPLETE
#setopt SHARE_HISTORY
#setopt APPEND_HISTORY
#setopt INC_APPEND_HISTORY
#setopt HIST_IGNORE_DUPS
#setopt HIST_FIND_NO_DUPS

# Enable colors and change prompt:
autoload -U colors && colors
PS1="%B%{$fg[yellow]%}%n%{$fg[green]%}@%{$fg[blue]%}%M %{$fg[magenta]%}%~ %(?.%F{green}%#.%F{red}%#)%f "

# prompt style
#PROMPT='%(?.%F{green}>.%F{red}>)%f %B%F{blue}%1~%f%b %# '

# Change cursor shape for different vi modes.
function zle-keymap-select {
  if [[ ${KEYMAP} == vicmd ]] ||
     [[ $1 = 'block' ]]; then
    echo -ne '\e[1 q'
  elif [[ ${KEYMAP} == main ]] ||
       [[ ${KEYMAP} == viins ]] ||
       [[ ${KEYMAP} = '' ]] ||
       [[ $1 = 'beam' ]]; then
    echo -ne '\e[5 q'
  fi
}
zle -N zle-keymap-select
zle-line-init() {
    zle -K viins # initiate `vi insert` as keymap (can be removed if `bindkey -V` has been set elsewhere)
    echo -ne "\e[5 q"
}
zle -N zle-line-init
echo -ne '\e[5 q' # Use beam shape cursor on startup.
preexec() { echo -ne '\e[5 q' ;} # Use beam shape cursor for each new prompt.

# git integration
autoload -Uz vcs_info
precmd_vcs_info() { vcs_info }
precmd_functions+=( precmd_vcs_info )
setopt prompt_subst
RPROMPT=\$vcs_info_msg_0_
zstyle ':vcs_info:git:*' formats '%F{blue}(%b)%r%f'
zstyle ':vcs_info:*' enable git

# java programs
export JDK_HOME="/usr/lib/jvm/java-1.8-openjdk"
# for tiling WMs
export _JAVA_AWT_WM_NONREPARENTING=1

# gpg signing
GPG_TTY=$(tty)
export GPG_TTY

# useful when using a display manager
source ~/.zprofile

# aliases
alias -g sudo="nocorrect sudo "
alias -g ls="ls --color"
alias ":q"="exit"
alias grep="grep --color"
alias l="ls -lAhL"
alias md="mkdir -p"
alias lampp="/opt/lampp/lampp"

alias proton="~/.steam/steam/steamapps/common/Proton\ 5.0/dist/bin/wine"
alias proton64="~/.steam/steam/steamapps/common/Proton\ 5.0/dist/bin/wine64"

# The following lines were added by compinstall
zstyle ':completion:*' completer _complete _ignored _approximate
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' menu select
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' verbose true
zstyle :compinstall filename '/home/mihai/.zshrc'

autoload -Uz compinit
compinit
_comp_options+=(globdots)
# End of lines added by compinstall

# Use vim keys in tab complete menu:
#bindkey -M menuselect 'h' vi-backward-char
#bindkey -M menuselect 'k' vi-up-line-or-history
#bindkey -M menuselect 'l' vi-forward-char
#bindkey -M menuselect 'j' vi-down-line-or-history
#bindkey -v '^?' backward-delete-char

# These plugins can be installed from xbps
# Load zsh-autosuggestions
#source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
# Load zsh-syntax-highlighting; should be last.
#source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh 2>/dev/null
