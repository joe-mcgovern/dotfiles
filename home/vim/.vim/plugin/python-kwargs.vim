" In python, convert kwargs to a dict and vise-versa. Using a visual
" selection, call <leader>td (Toggle Dict) and that will toggle kwargs/dict
" mode for the selection

if exists("g:python_kwargs_loaded")
    finish
endif

vnoremap <leader>td :<c-u>call ToggleKwargsOrDict(visualmode())<cr>

let g:python_kwargs_loaded = 1

function! ToggleKwargsOrDict(mode_type)
    if a:mode_type ==# 'v'
        execute "normal! `<v`>y"
    elseif a:mode_type ==# 'V'
        execute "normal! `<v`>y"
    elseif a:mode_type ==# 'char'
        execute "normal! `[v`]y"
    else
        return
    endif
    let l:selection = @@
    let l:lines = split(l:selection, '\n')
    for l:line in l:lines
        let l:kwargs = split(l:line, ',\s\?')
        for l:kwarg in l:kwargs
            if s:IsKwarg(l:kwarg)
                let l:newKwarg = s:ConvertToDict(l:kwarg)
                execute "'<,'>s/" . l:kwarg . "/" . l:newKwarg  . "/g"
            elseif s:IsDict(l:line)
                let l:newKwarg = s:ConvertToKwarg(l:kwarg)
                execute "'<,'>s/" . l:kwarg . "/" . l:newKwarg   . "/g"
            else
            endif
        endfor
    endfor
endfunction

function s:IsKwarg(line)
    return a:line =~ '^\s*[a-zA-Z\-\_0-9]+\='
endfunction

function s:IsDict(line)
    return a:line =~ '^\s*\"\?[a-zA-Z\-\_0-9]\+\"\?\:'
endfunction

function s:ConvertToDict(line)
    let l:pieces = split(a:line, '=')
    " TODO make this more failure-resistant!
    let l:word = split(l:pieces[0], " ")[0]
    let l:pieces[0] = substitute(l:pieces[0], l:word, '"' . l:word . '"', "")
    return join(l:pieces, ": ")
endfunction

function s:ConvertToKwarg(line)
    let l:pieces = split(a:line, ':\s*')
    " TODO make this more failure-resistant!
    let l:pieces[0] = substitute(l:pieces[0], "[\"']*", "", "g")
    return join(l:pieces, "=")
endfunction
