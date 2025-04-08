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

    find "$dir" -type f -iname "*$pattern*"
}
alias fn='fn_'
#------------------------------------------------------#

## look for a file that contains $pattern in it.
#---------------------------------------------------------#
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

    find "$dir" -type f -exec grep -i -l -- "$pattern" {} +
}
alias fg='fg_'
#---------------------------------------------------------#

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
alias sk='setxkbmap -option caps:escape'
alias cca='gcc *.c -Wall -Wextra -Werror && ./a.out'
alias ccf='gcc *.c -Wall -Wextra -Werror'
alias ccfl='ccf -pedantic -fno-omit-frame-pointer -fsanitize=address -fsanitize=undefined'
alias cl='ccf -g && lldb a.out'
#----------------------------------------------------------------------------------------#

# ===================================#
#           UBUNTU ALIASES           #
# ===================================#

if [ -n "$IS_UBUNTU" ]; then
	echo UBUNTU
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
getlib() {
    local src="$HOME/42/libft"
    local dst="./libft"

    git -C "$src" pull
    [ -d "$dst" ] && rm -rf "$dst"
    cp -r "$src" "$dst"; rm -rf "$dst/.git"
}
alias getlib="getlib"
#-----------------------------------------#

## exec tree and copies every $1 or .c files
## prefixed by their names.
#--------------------------------#
cpall_() {
    ext="${1:-c}"
    ( \
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
alias clip='xclip -selection clipboard'

# git
alias gst='git status'
alias gcl='git clone'
alias gp='git push'
alias gl='git pull'

alias ca='vim ~/.bash_aliases'
alias up='. ~/.bash_aliases'
#--------------------------------#

fi # CHAD-OS
