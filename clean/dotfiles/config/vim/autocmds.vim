
" Restore cursor position.
autocmd VimEnter * normal! '"

" Update header before saving.
augroup HeaderUpdate
    autocmd!
    autocmd BufWritePre * call UpdateHeader()
augroup END

