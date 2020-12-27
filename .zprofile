# start GPG agent
#gpg-agent --daemon --write-env-file "$HOME/.gpg-agent-info"
# seems to be started automatically by gpg

export BROWSER='firefox'
export TERMINAL='alacritty'
export EDITOR='nvim'

# path
export PATH="$PATH:$HOME/.local/bin:$HOME/.config/rofi/scripts:$HOME/.cargo/bin"
# manpath
export MANPATH="$MANPATH:/opt/texlive/2020/texmf-dist/doc/man"
# infopath
export INFOPATH="$INFOPATH:/opt/texlive/2020/texmf-dist/doc/info"
# fix Java programs in tiling WMs
export _JAVA_AWT_WM_NONREPARENTING=1
# fzf default search command
export FZF_DEFAULT_COMMAND="rg --files --hidden"
