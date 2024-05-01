# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias x='startx'

alias ls='ls --color=auto'
alias grep='grep --color=auto'

# Set "user@host" in red, ':' in magenta, current dir in purple and '$' in magenta "user@host:curr_dir$"
PS1='\[\033[38;2;255;0;0m\]\u@\h\[\033[38;2;255;0;255m\]:\[\033[38;2;102;0;255m\]$(basename "\w")\[\033[38;2;255;0;255m\]\$\[\033[0m\]\[\033[38;2;255;255;255m\] '

# Update st title for absolute path
update_st_title() {
    echo -ne "\033]0;${PWD}\007"
}
PROMPT_COMMAND=update_st_title

eval "$(zoxide init bash)"

source /home/$NUSER/.bash_aliases
