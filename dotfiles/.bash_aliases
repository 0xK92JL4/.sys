mkcd_() { mkdir "$1" && cd "$1"; }
alias mkcd='mkcd_'

pdf_() { mupdf -r 89 "$@" & }
alias pdf='pdf_'

fn_() { find ~ -iname "*$@*"; }
alias fn='fn_'

alias cca='gcc *.c -Wall -Wextra -Werror && ./a.out'
alias ccf='gcc *.c -Wall -Wextra -Werror'
alias ccfl='ccf -pedantic -fno-omit-frame-pointer -fsanitize=address -fsanitize=undefined'
alias cl='ccf -g && lldb a.out'

alias clip='xclip -selection clipboard'
alias cpgpt='{ \
    for file in ft_*.c; do \
        echo "$file"; \
        cat "$file"; \
        echo; \
    done; \
    echo "main.c"; \
    cat main.c; \
} | xclip -selection clipboard'
