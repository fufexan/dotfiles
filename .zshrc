#
# zsh configuration file
#

# where to store history file
HISTFILE=~/.cache/.histfile

# enable vi mode in the shell
bindkey -v
# enter normal mode instantly when pressing esc
export KEYTIMEOUT=1

# search history based on what's already typed in the prompt
# load the function
autoload -U history-search-end
# group functions
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
# bind functions to up and down arrow keys
bindkey "^[[A" history-beginning-search-backward-end
bindkey "^[[B" history-beginning-search-forward-end

# allow editing command in vim with ^E
autoload edit-command-line
zle -N edit-command-line
bindkey '^e' edit-command-line

# enable colors in the shell
autoload -U colors && colors
# change prompt
PS1="%B%F{yellow}%n%F{green}@%F{blue}%M %F{magenta}%~ %(?.%F{green}%#.%F{red}%#)%f "

# change cursor shape for different vi modes.
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

# case insensitive tab completion
zstyle ':completion:*' completer _complete _ignored _approximate
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' menu select
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' verbose true
_comp_options+=(globdots)

# useful when using a display manager
source ~/.zprofile

# aliases
alias -g sudo="nocorrect sudo"
alias -g ls="ls --color"
alias grep="grep --color"
alias ":q"="exit"
alias l="ls -lAhL"
alias md="mkdir -p"

# use pywal colors in terminal
(cat ~/.cache/wal/sequences &)

#
# options to enable if you do not use NixOS
#

# how much history to keep
#HISTSIZE=1000
#SAVEHIST=10000

# shell options
#setopt NO_CASE_GLOB
#setopt AUTO_CD
#setopt GLOB_COMPLETE
#setopt SHARE_HISTORY
#setopt APPEND_HISTORY
#setopt INC_APPEND_HISTORY
#setopt HIST_IGNORE_DUPS
#setopt HIST_FIND_NO_DUPS
