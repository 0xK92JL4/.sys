# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias x='startx'

# Colors
RED='\[\033[38;2;255;0;0m\]'
MAGENTA='\[\033[38;2;255;0;255m\]'
PURPLE='\[\033[38;2;102;0;255m\]'
WHITE='\[\033[38;2;255;255;255m\]'

# Prompt
PS1="${RED}\u@\h${MAGENTA}:${PURPLE}\W${MAGENTA}\$${WHITE} "

# Update st title for absolute path
update_st_title() {
    echo -ne "\033]0;${PWD}\007"
}
PROMPT_COMMAND=update_st_title

eval "$(zoxide init bash)"

cat $HOME/.notes

source $HOME/.bash_aliases

export PATH="$PATH:$HOME/.local/bin"
