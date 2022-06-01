nnoremap <leader>p :set operatorfunc=<SID>PrintOperator<cr>g@
vnoremap <leader>p :<C-u>call <SID>PrintOperator(visualmode())<cr>

function! s:PrintOperator(type)
    let saved_unnamed_register = @@
    if a:type ==# 'v'
        normal! `<v`>y
    elseif a:type ==# 'char'
        normal! `[v`]y
    else
        return
    endif

    let ft = &filetype
    if ft ==# 'python'
        silent execute "normal! oprint(\"" . @@ . " >>\", " . @@ . ")"
    elseif index(['javascript', 'typescript', 'typescriptreact', 'javascriptreact'], ft) >= 0
        silent execute "normal! oconsole.log(\"" . @@ . " >>\", " . @@ . ");"
    elseif ft ==# 'vim'
        silent execute "normal! oechom " . @@
    endif

    let @@ = saved_unnamed_register
endfunction
