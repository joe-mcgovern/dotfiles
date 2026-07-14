" Use <leader>g as an operator to grep for the text object you are operating
" on. For example run `<leader>giw` to grep for the 'inner word' under cursor.
" This also works for visually selected text, just run `<leader>g`

nnoremap <leader>g :set operatorfunc=<SID>GrepOperator<cr>g@
vnoremap <leader>g :<C-u>call <SID>GrepOperator(visualmode())<cr>

function! s:GrepOperator(type)
    let saved_unnamed_register = @@
    if a:type ==# 'v'
        normal! `<v`>y
    elseif a:type ==# 'char'
        normal! `[v`]y
    else
        return
    endif

    execute "Rg " . @@
    " This was what the 'learning vimscript the hard way' tutorial produced.
    " However, because I use ripgrep instead of grep, I decided to just invoke
    " that plugin instead
    " silent execute "grep! -R " . shellescape(@@) . " . --exclude-dir=node_modules --exclude-dir=.git"
    " copen
    let @@ = saved_unnamed_register
endfunction
