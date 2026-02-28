autocmd VimEnter * normal! '"
au BufRead,BufNewFile *.tpp set filetype=cpp
syntax on
filetype indent on
colorscheme koehler
set tabstop=4
set shiftwidth=4
set is hls

set relativenumber
set termguicolors
highlight LineNr guifg=#008000

command Header :0r !header %

function! UpdateHeader()
    if getline(1) !~ '^/\*┌'
        return
    endif

    let l:file = expand('%:t')
    let l:now  = strftime("%Y/%m/%d %H:%M:%S")

    " ---------- LINE 3 : FILENAME ----------
    let l:line3 = getline(3)
    if l:line3 =~ '^/\*│'
        let l:art = matchstr(l:line3, '▒.*')
        let l:new = printf('/*│  %-55s%s', l:file, l:art)
        call setline(3, l:new)
    endif

    " ---------- LINE 8 : UPDATED ----------
    let l:line8 = getline(8)
    if l:line8 =~ '^/\*│  Updated:'
        let l:author = matchstr(l:line8, 'by .*')
        let l:new = substitute(l:line8,
                    \ 'Updated:.\{-}by .*',
                    \ 'Updated: ' . l:now . ' ' . l:author,
                    \ '')
        call setline(8, l:new)
    endif
endfunction

autocmd BufWritePre * call UpdateHeader()

