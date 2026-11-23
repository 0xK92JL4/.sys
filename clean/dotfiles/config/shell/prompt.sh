
# Colors
_c() { printf '\\[\\033[38;2;%s;%s;%sm\\]' "$1" "$2" "$3"; }
RED=$(_c 255 0 0)
MAGENTA=$(_c 255 0 255)
PURPLE=$(_c 102 0 255)
WHITE=$(_c 255 255 255)

# Prompt
PS1="${RED}\u@\h${MAGENTA}:${PURPLE}\W${MAGENTA}\$${WHITE} "


# Update st title for absolute path
update_st_title() { printf '\033]0;%s\007' "$PWD"; }
PROMPT_COMMAND="update_st_title${PROMPT_COMMAND:+;$PROMPT_COMMAND}"

