mkcd_() { mkdir "$1" && cd "$1"; }
alias mkcd='mkcd_'

pdf_() { mupdf -r 89 "$@" & }
alias pdf='pdf_'

fn_() { find ~ -iname "*$@*"; }
alias fn='fn_'

fi_() {
    find ~ -type f -exec grep -l "$@" {} +
}
alias fi='fi_'

gcp_() {
    local commit=${1:-"some edits"}
	git commit -m "$commit" && git push
}

gall_() {
    local commit=${1:-"some edits 🗿"}
	git pull && git add * && git commit -a -m "$commit" && git push
}

getlib() {
    local src="$HOME/42/libft"
    local dst="./libft"

    git -C "$src" pull
    [ -d "$dst" ] && rm -rf "$dst"
    cp -r "$src" "$dst"; rm -rf "$dst/.git"
}

alias getlib="getlib"


alias ll='ls | cat'
alias ca='vim ~/.bash_aliases'
alias up='. ~/.bash_aliases'
alias cca='gcc *.c -Wall -Wextra -Werror && ./a.out'
alias ccf='gcc *.c -Wall -Wextra -Werror'
alias ccfl='ccf -pedantic -fno-omit-frame-pointer -fsanitize=address -fsanitize=undefined'
alias cl='ccf -g && lldb a.out'

# git
alias gall='gall_'
alias gst='git status'
alias gcl='git clone'
alias gcp='gcp_'
alias gp='git push'
alias gl='git pull'

alias clip='xclip -selection clipboard'
alias cpgpt='{ \
    for file in *.c; do \
        echo "$file"; \
        cat "$file"; \
        echo; \
    done; \
} | xclip -selection clipboard'
