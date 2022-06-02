" TODO this plugin should be updated to not allow modifying the loclist
" This plugin currently depends on vim-qfedit (https://github.com/itchyny/vim-qfedit)
" to allow editing/closing the loclist
" It would be better to design this plugin so that it has no dependencies.
" Update: this may be fixed by using COC to manage find/replace across a
" project.

nnoremap <leader>R :call SearchAndReplace()<CR>

let g:search_replace_pre_execution_options = get(g:, "search_replace_pre_execution_options", {})

" Interact with user to search & replace the word under cursor across the
" project
function! SearchAndReplace()
  " If this is run within the quickfix window, then go ahead and execute the
  " replacement on each entry within the quickfix.
  if &ft ==# "qf"
    if !exists("s:local_sr_search") || !exists("s:local_sr_replace")
      echom "No search result!"
    endif
    call s:DoReplacement()
    return
  endif
  call s:DoSearch()
endfunction

" Convert ripgrep result to a quickfix entry
function! s:ag_to_qf(line)
  let parts = split(a:line, ':')
  return {'filename': parts[0], 'lnum': parts[1], 'col': parts[2],
        \ 'text': join(parts[3:], ':')}
endfunction

" Take a ripgrep query, execute it, and push its results to the quickfix
" window
function! s:AgToQF(query)
  call setqflist([], 'r', {"title": "heculean title", "items": map(systemlist('rg --column "'. a:query . '"'), 's:ag_to_qf(v:val)')})
endfunction

function! s:DoSearch()
  " Save the current position - this will be used after all the replacements
  " have been applied to bring the user back to where he started
  let s:prevPos = getpos('.')
  let s:prevView = winsaveview()
  silent execute "normal! mZ"
  let wordUnderCursor = expand("<cword>")
  call inputsave()
  let s:local_sr_search = input("Search for: ", wordUnderCursor)
  call inputrestore()
  call inputsave()
  let s:local_sr_replace = input("Replace \"" . wordUnderCursor . "\" with: ")
  call inputrestore()
  call s:AgToQF(wordUnderCursor)
  " Open quickfix window
  copen
  " Allow user to edit qf entries
  " setlocal modifiable
  " silent execute "split ~/.vim-search-and-replace-data"
endfunction

function! s:DoReplacement()
  " Once the user has submitted the change, they should no longer be able to
  " edit the qf window without a manual override
  " setlocal nomodifiable
  let l:old_ef = &errorformat
  " Reload buffer so that the cdo command is executed for only the changes
  " that the user has configured to be within the qf window
  setlocal errorformat=%f\|%l\ col\ %c\|%m
  cgetbuffer
  let &errorformat=l:old_ef
  let l:prev_settings = s:ApplyPreExecutionSettings()
  " cdo silent execute "s/" . s:local_sr_search . "/" . s:local_sr_replace . "/g | w!"
  cdo silent execute "s/" . s:local_sr_search . "/" . s:local_sr_replace . "/g | w!"
  call s:ApplyPreviousSettings(l:prev_settings)
  unlet s:local_sr_search
  unlet s:local_sr_replace
  " Empty out quickfix - commenting this out for now because perhaps the
  " user would want to be able to go back and visit the files that were
  " changed, using the quickfix to do so?
  " setqflist(0, [])
  " lgetbuffer
  " Close qf window
  cclose
  " Jump back to where the user started
  silent execute "normal! `Z"
  if !empty(s:prevPos) && !empty(s:prevPos)
    call winrestview(s:prevView)
    call setpos('.', s:prevPos)
  endif
endfunction

function! s:ApplyPreExecutionSettings()
  let l:current_settings = {}
  for [key, value] in items(g:search_replace_pre_execution_options)
    silent execute "let l:current_settings[\"" . key . "\"] = " . key
    silent execute "let " . key . "=" . value
  endfor
  return l:current_settings
endfunction

function! s:ApplyPreviousSettings(prev_settings)
  for [key, value] in items(a:prev_settings)
    silent execute "let " . key . "=" . value
  endfor
endfunction
