#bindkey -M vicmd "k" history-substring-search-up zshrc file is from lukesmith.xyz
source /usr/share/zsh/scripts/zplug/init.zsh 
autoload -U colors && colors


# History in cache directory: 
HISTSIZE=10000
HISTFILE=~/.zhistory SAVEHIST=10000 
setopt    appendhistory
setopt    incappendhistory
# Basic auto/tab complete:
autoload -U compinit
zstyle ':completion:*' menu select
zmodload zsh/complist
compinit
_comp_options+=(globdots)		# Include hidden files.

# vi mode
bindkey -v
export KEYTIMEOUT=1

fh() {
  print -z $( ([ -n "$ZSH_NAME" ] && fc -l 1 || history) | fzf +s --tac | sed -r 's/ *[0-9]*\*? *//' | sed -r 's/\\/\\\\/g')
}
# Use vim keys in tab complete menu:
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -v '^?' backward-delete-char
#bindkey '^R' history-incremental-search-backward
#bindkey '^R' fh()

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

# Use lf to switch directories and bind it to ctrl-o
lfcd () {
    tmp="$(mktemp)"
    lf -last-dir-path="$tmp" "$@"
    if [ -f "$tmp" ]; then
        dir="$(cat "$tmp")"
        rm -f "$tmp"
        [ -d "$dir" ] && [ "$dir" != "$(pwd)" ] && cd "$dir"
    fi
}
bindkey -s '^o' 'lfcd\n'

# Edit line in vim with ctrl-e:
autoload edit-command-line; zle -N edit-command-line
bindkey '^e' edit-command-line

# Load aliases and shortcuts if existent.
[ -f "$HOME/.config/shortcutrc" ] && source "$HOME/.config/shortcutrc"
[ -f "$HOME/.config/aliasrc" ] && source "$HOME/.config/aliasrc"

# Load zsh-syntax-highlighting; should be last.
export LANG=en_US.UTF-8
#zplug "denysdovhan/spaceship-prompt", use:spaceship.zsh, from:github, as:theme
zplug "zsh-users/zsh-completions"
zplug "zsh-users/zsh-autosuggestions"
zplug "zsh-users/zsh-syntax-highlighting"
zplug "zsh-users/zsh-history-substring-search"
zplug "plugins/fasd",   from:oh-my-zsh
zplug load
SPACESHIP_TIME_SHOW=true
SPACESHIP_DOCKER_SHOW=false

eval "$(starship init zsh)"
# Alias for git bare repository
# Ctrl + Space to accept the suggestion
bindkey '^ ' autosuggest-accept
source ~/z.sh
source /opt/ros/melodic/setup.zsh
export PYTHONPATH=${PYTHONPATH}:/home/rahul/naoqi/pynaoqi-python2.7-2.5.5.5-linux64/lib/python2.7/site-packages
export PATH="/home/rahul/.pyenv/bin:$PATH"
PATH="$PATH:$(ruby -e 'puts Gem.user_dir')/bin"

# Dotbare configs
export DOTBARE_DIR="$HOME/.cfgs"
export DOTBARE_FZF_DEFAULT_OPTS="--preview-window=right:65%"
export EDITOR=nvim

# FZF configs.
export FZF_DEFAULT_COMMAND='fd --type f --hidden '
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
source ~/.dotbare/dotbare.plugin.zsh
