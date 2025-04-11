# ===================================#
#           COMMON ALIASES           #
# ===================================#

## create a dir a go in it.
#--------------------------------#
mkcd_() { mkdir "$1" && cd "$1"; }
alias mkcd='mkcd_'
#--------------------------------#

## look for a filename that contains $pattern.
#------------------------------------------------------#
fn_() {
    local dir="$1"
    local pattern="$2"

    if [ -z "$dir" ] || [ -z "$pattern" ]; then
        echo "Usage: fg_filenames <directory> <pattern>"
        return 1
    fi

    if [ ! -d "$dir" ]; then
        echo "Error: '$dir' is not a valid directory."
        return 1
    fi

    find "$dir" -type f -iname "*$pattern*" 2>/dev/null
}
alias fn='fn_'
#------------------------------------------------------#

## look for a file that contains $pattern in it.
#---------------------------------------------------------------------#
fg_() {
    local dir="$1"
    local pattern="$2"

    if [ -z "$dir" ] || [ -z "$pattern" ]; then
        echo "Usage: search_files <directory> <pattern>"
        return 1
    fi

    if [ ! -d "$dir" ]; then
        echo "Error: '$dir' is not a valid directory."
        return 1
    fi

    find "$dir" -type f -exec grep -i -l -- "$pattern" {} + 2>/dev/null
}
alias fg='fg_'
#---------------------------------------------------------------------#

## commit and push stagged files.
#-------------------------------------#
gcp_() {
    local commit=${1:-"some edits"}
	git commit -m "$commit" && git push
}
alias gcp='gcp_'
#-------------------------------------#


## pull, add everything, commit with $1 or "some edits" and push.
#-----------------------------------------------------------------#
gall_() {
    local commit=${1:-"some edits 🗿"}
	git pull && git add * && git commit -a -m "$commit" && git push
}
alias gall='gall_'
#-----------------------------------------------------------------#

## check for norm errors.
#-------------------------------------------------------------------------------#
err_() {
    norminette | awk '
    /Error!$/ {
        error_count++;
        if (error_count > 1) { print ""; }
        print "\033[1;38;2;147;117;42m" $0 "\033[0m";
        next;
    }
    /OK!$/ { next; }

    { print "\033[0;38;2;94;123;155m" $0 "\033[0m"; }

    END { if (error_count == 0) print "\033[1;38;2;64;148;42mNo Error!\033[0m"; }
    '
}
alias err='err_'
#-------------------------------------------------------------------------------#

## repeat the last command.
#-------------------------#
r_() {
    eval "$(fc -ln -1)"
    history -d $(history 1)
}
alias r='r_'
#-------------------------#

## repeat the last last command.
#-------------------------#
rr_() {
	eval "$(history | tail -n 3 | head -n 1 | awk '{$1=""; print $0}')"
    history -d $(history 1)
}
alias rr='rr_'
#-------------------------#

## basic aliases.
#----------------------------------------------------------------------------------------#
alias cca='gcc *.c -Wall -Wextra -Werror && ./a.out'
alias ccf='gcc *.c -Wall -Wextra -Werror'
alias ccfl='ccf -pedantic -fno-omit-frame-pointer -fsanitize=address -fsanitize=undefined'
alias cl='ccf -g && lldb a.out'
alias kd='killall Discord'
alias ks='setxkbmap -option'
alias sk='setxkbmap -option caps:escape'
alias hh='df -h $HOME && echo -e "\nSome_heavy_files:" && du -ht 100M $HOME | sort | uniq'

# TMP
alias bp='bash --posix'
#----------------------------------------------------------------------------------------#

# ===================================#
#           UBUNTU ALIASES           #
# ===================================#

if [ -n "$IS_UBUNTU" ]; then

echo UBUNTU

## to auto create the dirs for new project
#-----------------------------------------------#
ltu_() {
    mkdir "$1" &&{
        mkdir "$1/${1}_L" && touch "$1/${1}_L/🙃"
        mkdir "$1/${1}_T" && touch "$1/${1}_T/😈"
        mkdir "$1/${1}_U" && touch "$1/${1}_U/🗿"
    }
	git add $1
	git commit -m "Created $1"
	git push
}
alias ltu='ltu_'
#-----------------------------------------------#

## cat with colors for supported files or default cat
#---------------------------------------------------------#
cat_() {
  if pygmentize -O style=native "$1" > /dev/null 2>&1; then
    pygmentize -O style=native "$@"
  else
    command cat "$@"
  fi
}
alias cat='cat_'
#---------------------------------------------------------#

## rebuild the 42LTU folder to repair git conflict
#---------------------------------------------------------------------------#
refresh_ltu_() {
  local repo_name="42LTU"
  local repo_url="git@github.com:lucasluc44/42LTU.git"
  local repo_path=$(find ~ -type d -name "$repo_name" 2>/dev/null | head -n 1)

  if [ -z "$repo_path" ]; then
    echo "No $repo_name found in your home directory (~)."
    return 1
  fi

  echo "Found $repo_name at: $repo_path"
  echo "Removing $repo_path..."
  rm -rf "$repo_path" && \
  git clone "$repo_url" "$repo_path" && \
  echo "Successfully refreshed $repo_name at $repo_path."
}
alias refresh_ltu='refresh_ltu_'
#---------------------------------------------------------------------------#

## copies the latest libft.
#-----------------------------------------#
getlib_w() {
    local src="$HOME/42/libft"
    local dst="./libft"

    git -C "$src" pull
    [ -d "$dst" ] && rm -rf "$dst"
    cp -r "$src" "$dst"; rm -rf "$dst/.git"
}
alias getlib='getlib_w'
#-----------------------------------------#

## copies file passed in $1
#--------------------------------------#
clip_() { cat "$1" | xsel --clipboard; }
alias clip='clip_'
#--------------------------------------#

## copies the latest libft.
#------------------------------------#
cpall_() {
    local ext="${1:-c}"
    (
        tree
        for file in *."$ext"; do
            echo "$file"
            cat "$file"
            echo
        done
    ) | xsel --clipboard
}
alias cpall='cpall_'
#------------------------------------#

## make tree print an actual tree
#---------------------------------#
alias tree='printf "
\033[30m.      \033[32m_-_
    /~~   ~~\\
 /~~         ~~\\
{               }
 \\  _-     -_  /
   ~  \033[33m\\\\\\ //  \033[32m~
_- -   \033[33m| | \033[32m_- _
  _ -  \033[33m| |   \033[32m-_
      \033[33m// \\\\\\ \n\033[0m"'
#---------------------------------#

###alias norminette='norminette | tee /dev/tty | grep -q "Error" && (sleep 3 && echo killall5)'
###alias code='echo "zsh: command not found: code" && echo "did you mean: vim"; sleep 3; echo; echo "uhh... alright, i'\''ll open you vscode..."; sleep 2; code'

## basic aliases.
#--------------------------------------------#
alias ca='vim ~/.bash_aliases'
alias up='source ~/.bash_aliases'
alias getmain='cp ~/42/correction/current_main/* ./main.c'
alias corr='terminator --geometry=1920x2160+0+0 -e "bash -c \"mkdir -p /tmp/correction && cd /tmp/correction && clear && /usr/lib/firefox/firefox -private-window; exec zsh\""'
alias endcorr='rm -rf /tmp/correction && exit'
alias cleantmp='find /tmp -user "$USER" 2>/dev/null -exec rm -rf {} +'
#--------------------------------------------#

fi # UBUNTU

# ===================================#
#          CHAD-OS ALIASES           #
# ===================================#

if [ -n "$CHAD_OS" ]; then

## open a pdf.
#---------------------------#
pdf_() { mupdf -r 89 "$@" & }
alias pdf='pdf_'
#---------------------------#

## copies the latest libft.
#-----------------------------------------#
getlib_h() {
    local src="$HOME/42/libft"
    local dst="./libft"

    git -C "$src" pull
    [ -d "$dst" ] && rm -rf "$dst"
    cp -r "$src" "$dst"; rm -rf "$dst/.git"
}
alias getlib="getlib_h"
#-----------------------------------------#

## exec tree and copies every $1 or .c files
## prefixed by their names.
#--------------------------------#
cpall_() {
    local ext="${1:-c}"
    (
        tree
        for file in *.$ext; do
            echo "$file"
            cat "$file"
            echo
        done
    ) | xclip -selection clipboard
}
alias cpall='cpall_'
#--------------------------------#

## basic aliases.
#-------------------------------------#
alias ca='vim ~/.bash_aliases'
alias up='. ~/.bash_aliases'
alias clip='xclip -selection clipboard'
alias gst='git status'
alias gcl='git clone'
alias gp='git push'
alias gl='git pull'
#--------------------------------#

fi # CHAD-OS
