
" Enable filetype detection and indentation
filetype plugin indent on
syntax on

" -----------------------------------
" C / C++
" -----------------------------------
autocmd FileType c,cpp setlocal
            \ tabstop=4
            \ shiftwidth=4
            \ softtabstop=4
            \ expandtab

" Recognize .tpp as C++
autocmd BufRead,BufNewFile *.tpp setfiletype cpp

" -----------------------------------
" Ruby
" -----------------------------------
autocmd FileType ruby setlocal
            \ tabstop=2
            \ shiftwidth=2
            \ softtabstop=2
            \ expandtab

" -----------------------------------
" YAML
" -----------------------------------
autocmd FileType yaml setlocal
            \ tabstop=2
            \ shiftwidth=2
            \ softtabstop=2
            \ expandtab

" -----------------------------------
" Python
" -----------------------------------
autocmd FileType python setlocal
            \ tabstop=4
            \ shiftwidth=4
            \ softtabstop=4
            \ expandtab

" -----------------------------------
" JavaScript / TypeScript / JSON
" -----------------------------------
autocmd FileType javascript,typescript,json setlocal
            \ tabstop=2
            \ shiftwidth=2
            \ softtabstop=2
            \ expandtab

" -----------------------------------
" HTML / CSS
" -----------------------------------
autocmd FileType html,css,scss setlocal
            \ tabstop=2
            \ shiftwidth=2
            \ softtabstop=2
            \ expandtab

" -----------------------------------
" Lua
" -----------------------------------
autocmd FileType lua setlocal
            \ tabstop=2
            \ shiftwidth=2
            \ softtabstop=2
            \ expandtab

" -----------------------------------
" Vimscript
" -----------------------------------
autocmd FileType vim setlocal
            \ tabstop=2
            \ shiftwidth=2
            \ softtabstop=2
            \ expandtab

" -----------------------------------
" Shell scripts
" -----------------------------------
autocmd FileType sh,bash,zsh setlocal
            \ tabstop=4
            \ shiftwidth=4
            \ softtabstop=4
            \ expandtab

" -----------------------------------
" Makefiles
" -----------------------------------
autocmd FileType make setlocal
            \ tabstop=8
            \ shiftwidth=8
            \ softtabstop=0
            \ noexpandtab

