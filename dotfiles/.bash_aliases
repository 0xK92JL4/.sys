mkcd_() { mkdir "$1" && cd "$1"; }
alias mkcd='mkcd_'

pdf_() { mupdf -r 89 "$@" & }
alias pdf='pdf_'

alias cca='gcc *.c -Wall -Wextra -Werror && ./a.out'
alias ccf='gcc *.c -Wall -Wextra -Werror'

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

token_() { cat /home/$NUSER/.token/"$1" | xclip -selection clipboard; }
alias token='token_'

alias odays='sudo -b libreoffice /media/days.ods'
