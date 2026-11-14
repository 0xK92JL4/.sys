
hh() {
    df -h "$HOME"
    printf '\nSome heavy files:\n'
    du -ht 100M "$HOME" 2>/dev/null | sort -hr
}

hr() {
    df -h /
    printf '\nSome heavy files:\n'
    du -ht 100M \
        --exclude=/home \
        --exclude=/media \
        / 2>/dev/null | sort -hr
}
