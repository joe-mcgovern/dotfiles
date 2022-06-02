" Use za in normal mode to unfold any section
" Use zR to expand all folds
" Use zM to close all folds
"
" Currently using ALE to make vim act like an IDE for python, and Coc for
" everything else. Unfortunately, Coc doesn't have a plugin that respects
" virtualenvs, which every project I work on uses. I also wasn't able to find
" an easy way to enable isort and black.
"
let g:terraform_fmt_on_save = 1

" Basic settings ---------------------- {{{

" Configure python to be python3
set pyxversion=3

" Use spaces instead of tabs
set expandtab

" Set default number of spaces per tab
set tabstop=4

" Set default number of spaces per indentation
set shiftwidth=4

set autoindent
set smartindent

" Set <Leader> key to `,`
let mapleader=","

" Allow copying to / pasting from system clipboard
set clipboard=unnamed

" Configure line numbers
set number
set relativenumber

" Ignore case when searching buffer
set ignorecase

" Allow `:find` to search recursively
set path+=**

" Use this vim configuration when editing a vimrc file
set nocp

" Enable syntax highlighting
syntax on

" Highlight a column to know when to break
set colorcolumn=80

" Highlight all matches when searching
set hlsearch

" Set syntax theme to monokai. Vim has some built in schemes, but
" custom ones can be added via the ~/.vim/colors directory
colorscheme monokai

" Strip trailing whitespace on save
function StripTrailingWhitespace ()
    " don't strip on these filetypes
    if &ft =~ 'markdown'
        return
    endif
    %s/\s\+$//e
endfunction

augroup strip_whitespace
  autocmd!
  autocmd BufWritePre * call StripTrailingWhitespace()
augroup END

" function Autosave ()
"   if &ft =~ "startify"
"     return
"   endif
"   execute ":w"
" endfunction
"
" augroup save_on_leave
"   autocmd!
"   " Maybe this should be FocusLost?
"   autocmd InsertLeave * call Autosave()
" augroup END


" }}}

" Global Mappings ---------------------- {{{
" Use `jk` to go into normal mode
inoremap jk <ESC>

" Use magic regex all the time! Magic regex is the type of regex that is
" normally used in other languages. Also, enable hlsearch even if it was
" previously disabled.
nnoremap / :set hlsearch<cr>/\v

" Grep for word under cursor
nnoremap <leader>G :silent execute "RG \\b" . expand("<cword>") . "\\b"<cr>

" Find/replace in project using ripgrep
" This is now automatically defined in the search-and-replace plugin I wrote.
" nnoremap <leader>R :call SearchAndReplace()<CR>
" Search and replace word under cursor within current file
nnoremap <leader>r :%s/<C-r><C-w>/

" Open file under cursor
" Don't do this - just use gf ("go to file")
" nnoremap <leader>o gf

" Toggle search highlight
nnoremap <leader>h :set hlsearch!<CR>

" Map next/previous quickfix error
nnoremap <leader>ne :cnext<CR>
nnoremap <leader>pe :cprevious<CR>

" Open vimrc for editing using `ev`
nnoremap ev :split $MYVIMRC<CR>
" Reload vimrc using `rv`
nnoremap rv :source $MYVIMRC<CR>

" Override vim's default 'jump to tag' command with ALE's. I did this because
" ALE's seemed to do a better job of jumping to the actual defintion (as
" opposed to jumping to the nearest import or something).
" nnoremap <C-]> :keepjumps ALEGoToDefinition<CR>
" Temporarily disabling while testing COC
" nnoremap <C-]> :ALEGoToDefinition<CR>
" Use <Leader>J to jump to the definition of the word under the cursor.
nnoremap <Leader>J :ALEGoToDefinition<CR>

" Use <Leader>I to attempt to import the word under cursor
nnoremap <Leader>I :ALEImport<CR>

" Open up the list of buffers using fzf
nnoremap <Leader>b :Buffers<CR>

" Explore the file tree
nnoremap <Leader>e :NERDTreeToggle<CR>

" Start fzf using fz
nnoremap fz :Files<CR>

" Use Control-d to delete the current line in insert mode
inoremap <C-d> <esc>dd$a
" Use Leader-U to uppercase the current word in normal mode
nnoremap <Leader>U viwU
" Use Leader-L to lowercase the current word in normal mode
nnoremap <Leader>L viwu

" Use <Leader>' to surround current visual selection in single quotes
vnoremap <leader>' <esc>`<i'<esc>`>lli'<esc>
" Use <Leader>" to surround current visual selection in double quotes
vnoremap <leader>" <esc>`<i"<esc>`>lli"<esc>

" GIT BINDINGS
nnoremap <Leader>ga :Gwrite<CR>
nnoremap <Leader>gs :Git save<CR>
nnoremap <Leader>gc :Git commit<CR>
nnoremap <Leader>gp :Git push<CR>
nnoremap <Leader>gfp :Git fp<CR>

cabbr Rename GRename

" Use <C-X><C-J> when on a word to wrap it in a tag and add a closing tag to
" it
inoremap <silent> <buffer> <C-X><C-J> <Esc>ciW<Lt><C-R>"<C-R>=<CR>></<C-R>"><Esc>F<i

" Use :RG <regex> to invoke ripgrep with the provided regex and have fzf
" render the results.
command! -nargs=* -bang RG call RipgrepFzf(<q-args>, <bang>0)

" Bindings for copying current filename onto clipboard
nnoremap <Leader>yp :let @+ = expand('%')<CR>
nnoremap <Leader>yfp :let @+ = expand('%:p')<CR>

" }}}

" COC ---------------------- {{{
" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=300

" Some servers have issues with backup files, see #649.
set nobackup
set nowritebackup

set hidden

nmap <leader>rn <Plug>(coc-rename)
nnoremap <leader>qf  <Plug>(coc-fix-current)

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
nnoremap <silent> [g <Plug>(coc-diagnostic-prev)
nnoremap <silent> ]g <Plug>(coc-diagnostic-next)

nmap <silent> <C-]> <Plug>(coc-definition)

" Show all diagnostics
nnoremap <Leader>E :CocDiagnostics<CR>

augroup coc_filetype_javascript
  autocmd!
  " Use ,F to fix the problem under cursor
  autocmd FileType typescriptreact,typescript,javascript nnoremap <silent><leader>F :call CocAction('runCommand', 'tsserver.executeAutofix')<CR>
augroup END

augroup coc_filetype_python
  autocmd!
  " Format on save
  " autocmd BufWritePre *.py :call CocAction("format")
  autocmd BufWritePre *.py :call CocAction("runCommand", "python.sortImports")
  autocmd FileType typescriptreact,typescript,javascript nnoremap <silent><leader>F :call CocAction('runCommand', 'pyright.executeAutofix')<CR>
augroup END

augroup coc_filetype_markdown
  autocmd!
  autocmd FileType markdown let b:coc_suggest_disable = 1
augroup END

" Change error message color to white
highlight CocErrorHighlight ctermfg=White guifg=#ffffff
highlight CocErrorVirtualText ctermfg=White guifg=#ffffff
highlight CocErrorFloat ctermfg=White guifg=#ffffff
highlight CocErrorSign ctermfg=White guifg=#ffffff

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
if has("nvim-0.5.0") || has("patch-8.1.1564")
  " Recently vim can merge signcolumn and number column into one
  set signcolumn=number
else
  set signcolumn=yes
endif

" }}}

" Filetype specific mappings ---------------------- {{{

" Function used by abbreviations to eat trailing whitespace
func Eatchar(pat)
  let c = nr2char(getchar(0))
  return (c =~ a:pat) ? '' : c
endfunc

" python {{{
augroup filetype_python
  autocmd!
  " Use <leader>cfn to copy/paste the current function and drop you into
  " insert mode to replace the function name.
  " You can think of this as "copy function"
  autocmd FileType python nnoremap <buffer> <leader>cfn ?^\s*def <CR>?^$<CR>:nohlsearch<CR>V/^\s*def <CR>n?^$<CR>y/^\s*def <CR>n?^$<CR>dd"0P/^\s*def <CR>:nohlsearch<CR>ffwcw
  " Use <leader>ctfn to copy/paste the current function and drop you into
  " insert mode to replace the function name, prefixing the function name with
  " test_
  " You can think of this command like "copy test function"
  autocmd FileType python nnoremap <buffer> <leader>ctfn ?^\s*def <CR>?^$<CR>:nohlsearch<CR>V/^\s*def <CR>n?^$<CR>y/^\s*def <CR>n?^$<CR>dd"0P/^\s*def <CR>:nohlsearch<CR>ffwwi_

  " Use <leader>dfn to delete the current function.
  " You can think of this command like "delete function"
  autocmd FileType python nnoremap <buffer> <leader>dfn ?^\s*def <CR>?^$<CR>:nohlsearch<CR>V/^\s*def <CR>n?^$<CR>:nohlsearch<CR>kd
  autocmd FileType python onoremap <buffer> fn :<c-u>execute "normal! ?^\s*def \r?^$\r:nohlsearch\rV/^\s*def \rn?^$\r"<CR>:nohlsearch<CR>
augroup END
" }}}

" javascript {{{
augroup filetype_javascript
  autocmd!
  " Use fp in insert mode to add a new print
  autocmd FileType typescriptreact,typescript,javascript iabbrev  <buffer> clg console.log()<left><C-R>=Eatchar('\s')<CR>
  " Use iff in insert mode to add a new if statement
  autocmd FileType typescriptreact,typescript,javascript iabbrev  <buffer> iff if()<left><C-R>=Eatchar('\s')<CR>
  " Use rn to add a return statement
  autocmd FileType typescriptreact,typescript,javascript iabbrev  <buffer> rn return
augroup END
" }}}

" gitcommit {{{
augroup filetype_gitcommit
  autocmd!
  " Highlight columns for git commit message 50 for subject, 72 for body
  autocmd FileType gitcommit set colorcolumn=50,72
  autocmd FileType gitcommit setlocal spell spelllang=en_us
augroup END
" }}}

" markdown {{{
augroup filetype_markdown
  autocmd!
  autocmd FileType markdown setlocal spell spelllang=en_us
augroup END
" }}}

" Replace hashtags with double quotes for vimrc files
function ReplaceStartingHashtagsWithDoubleQuotes ()
  %s/^\(\s*\)#/\1"/e
endfunction

" vim {{{
augroup filetype_vim
  autocmd!
  autocmd FileType vim setlocal foldmethod=marker foldlevelstart=0 shiftwidth=2 tabstop=2
  autocmd Filetype vim iabbrev <buffer> == ==#
  autocmd BufWritePre *.vimrc call ReplaceStartingHashtagsWithDoubleQuotes()
augroup END
" }}}

" }}}

" Status line ---------------------- {{{
" Configure status line
let g:lightline = {
  \     'active': {
  \         'left': [['mode', 'paste' ], ['cocstatus', 'gitbranch', 'readonly', 'relativepath', 'modified']],
  \     },
  \     'component_function': {
  \         'gitbranch': 'fugitive#head',
  \         'cocstatus': 'coc#status',
  \     },
  \ }

  " Use autocmd to force lightline update.
  autocmd User CocStatusChange,CocDiagnosticChange call lightline#update()

" }}}

" Plugin configuration ---------------------- {{{
"
" This was for a custom plugin I made for completions within gitlab ci.
" I have since installed deoplete which takes care of this for me.
" let g:search_replace_pre_execution_options = {
"       \ "g:ale_fix_on_save": 0
"       \}

" {{{ Deoplete

" TEMPORARILY disabling while I test out coc
" set runtimepath+=~/.vim/pack/plugins/start/deoplete.nvim
" let g:deoplete#enable_at_startup = 1
" call deoplete#custom#option({
"       \ 'auto_complete_delay': 100,
"       \ 'max_list': 20,
"       \ 'yarp': 1,
"       \})

" }}}

" FZF ---------------------- {{{
function! s:build_quickfix_list(lines)
  call setqflist(map(copy(a:lines), '{ "filename": v:val }'))
  copen
  cc
endfunction

let g:fzf_action = {
  \ 'ctrl-q': function('s:build_quickfix_list'),
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-x': 'split',
  \ 'ctrl-v': 'vsplit' }

let $FZF_DEFAULT_OPTS = '--bind ctrl-a:select-all'

" }}}

" Gutentags {{{
let g:gutentags_add_default_project_roots = 0
let g:gutentags_project_root = ['package.json', '.git']
let g:gutentags_cache_dir = expand('~/.cache/vim/ctags/')
let g:gutentags_generate_on_write = 1
let g:gutentags_generate_on_new = 1
let g:gutentags_generate_on_missing = 1
let g:gutentags_ctags_extra_args = [
      \ '--tag-relative=yes',
      \ '--fields=+ailmnS',
      \ ]

let g:gutentags_ctags_exclude = [
      \ '*.git', '*.svg', '*.hg',
      \ '*/tests/*',
      \ 'build',
      \ 'dist',
      \ '*sites/*/files/*',
      \ 'bin',
      \ 'node_modules',
      \ 'bower_components',
      \ 'cache',
      \ 'compiled',
      \ 'docs',
      \ 'example',
      \ 'bundle',
      \ 'vendor',
      \ '*.md',
      \ '*-lock.json',
      \ '*.lock',
      \ '*bundle*.js',
      \ '*build*.js',
      \ '.*rc*',
      \ '*.json',
      \ '*.min.*',
      \ '*.map',
      \ '*.bak',
      \ '*.zip',
      \ '*.pyc',
      \ '*.class',
      \ '*.sln',
      \ '*.Master',
      \ '*.csproj',
      \ '*.tmp',
      \ '*.csproj.user',
      \ '*.cache',
      \ '*.pdb',
      \ 'tags*',
      \ 'cscope.*',
      \ '*.css',
      \ '*.less',
      \ '*.scss',
      \ '*.exe', '*.dll',
      \ '*.mp3', '*.ogg', '*.flac',
      \ '*.swp', '*.swo',
      \ '*.bmp', '*.gif', '*.ico', '*.jpg', '*.png',
      \ '*.rar', '*.zip', '*.tar', '*.tar.gz', '*.tar.xz', '*.tar.bz2',
      \ '*.pdf', '*.doc', '*.docx', '*.ppt', '*.pptx',
      \ ]
" }}}

" ALE {{{
" pylsp is the language server. pylsp was installed using the following
" command: pipx install 'python-lsp-server[rope, pyflakes]'
" rope provides the completions and renaming
" pyflakes detects various errors
" let g:ale_linters = {
"             \    'go': ['gopls'],
"             \    'python': ['pylsp'],
"             \    'typescript': ['eslint', 'tsserver'],
"             \    'typescriptreact': ['eslint', 'tsserver'],
"             \    'javascript': ['eslint', 'tsserver'],
"             \    'javascriptreact': ['eslint', 'tsserver'],
"             \    'terraform': ['terraform'],
"             \}
" let g:ale_linters = {
"             \    'python': ['pylsp'],
"             \}
let g:ale_linters = {}

" let g:ale_fixers = {
"             \    'go': ['goimports', 'remove_trailing_lines', 'trim_whitespace'],
"             \    'python': ['autoflake', 'isort', 'black', 'remove_trailing_lines', 'trim_whitespace'],
"             \    'typescript': ['prettier', 'remove_trailing_lines', 'trim_whitespace'],
"             \    'typescriptreact': ['prettier', 'remove_trailing_lines', 'trim_whitespace'],
"             \    'javascript': ['prettier', 'remove_trailing_lines', 'trim_whitespace'],
"             \    'javascriptreact': ['prettier', 'remove_trailing_lines', 'trim_whitespace'],
"             \    'terraform': ['terraform', 'remove_trailing_lines', 'trim_whitespace'],
"             \}
" let g:ale_fixers = {
"             \    'python': ['autoflake', 'isort', 'black', 'remove_trailing_lines', 'trim_whitespace'],
"             \}
let g:ale_fixers = {}
let g:ale_fix_on_save = 1
let g:ale_lint_delay = 100
let g:ale_lint_on_enter = 1
let g:ale_lint_on_save = 1
" Only run linters named in ale_linters settings.
let g:ale_linters_explicit = 1
let g:ale_lint_on_text_changed = 0
let g:ale_set_loclist = 1
let g:ale_set_quickfix = 0
let g:ale_open_list = 1
let g:ale_list_window_size = 3
" let g:ale_python_auto_pipenv = 1
" let g:ale_python_auto_poetry = 1
" let g:ale_python_black_auto_pipenv = 1
" let g:ale_python_black_auto_poetry = 1
" let g:ale_python_isort_auto_pipenv = 1
" let g:ale_python_isort_auto_poetry = 1

" augroup ale_filetype_python
"   autocmd!
"   " Use ,F to fix the problem under cursor
"   "
"   autocmd Filetype python nnoremap <silent> <C-]> :ALEGoToDefinition<CR>
" augroup END

" Have clicking tab and shift-tab cycle through autocomplete suggestions
inoremap <silent><expr> <Tab> pumvisible() ? "\<C-n>" : "\<TAB>"
inoremap <silent><expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-TAB>"
" This is for COC
" Make <CR> auto-select the first completion item and notify coc.nvim to
" format on enter, <cr> could be remapped by other vim plugin
inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

" Temporarily turning this off because I'm not that it's effective
" augroup clear_jumps
"   autocmd!
"   autocmd VimEnter * :clearjumps
" augroup END

" }}}

" Startify {{{
" Don't let startify change the directory
let g:startify_change_to_dir = 0
" }}}

" Vimwiki {{{
" Only files in the wiki directory should have a vimwiki filetype
let g:vimwiki_global_ext = 0
let g:vimwiki_option_syntax = 'markdown'
let g:vimwiki_list = [
    \ {'path': '~/vimwiki/', 'syntax': 'markdown', 'ext': '.md',
    \ 'links_space_char': '-', 'html_filename_parameterization': 1,
    \ 'custom_wiki2html': 'vimwiki_markdown', 'template_path': '~/vimwiki/templates/',
    \ 'template_default': 'default', 'template_ext': '.tpl'},
    \ ]
" }}}

" {{{ Rhubarb
" Configure rhubarb-vim to look at Granular's gitlab domain
let g:github_enterprise_urls = ['https://gitlab.internal.granular.ag']
" }}}


" }}}

" Custom functions ---------------------- {{{

function! RipgrepFzf(query, fullscreen)
  let command_fmt = 'rg --column --line-number --no-heading --color=always --smart-case -- %s || true'
  let initial_command = printf(command_fmt, shellescape(a:query))
  let reload_command = printf(command_fmt, '{q}')
  let spec = {'options': ['--phony', '--query', a:query, '--bind', 'change:reload:'.reload_command]}
  call fzf#vim#grep(initial_command, 1, fzf#vim#with_preview(spec), a:fullscreen)
endfunction

let g:search_replace_pre_execution_options = {"g:ale_fix_on_save": 0}

function! ApplyPreExecutionSettings()
  let l:current_settings = {}
  for [key, value] in items(g:search_replace_pre_execution_options)
    execute "echom " . key
    silent execute "let l:current_settings[\"" . key . "\"] = " . key
    silent execute "let " . key . "=" . value
  endfor
  echom l:current_settings
  return l:current_settings
endfunction

" }}}

"" Use emoji-fzf and fzf to fuzzy-search for emoji, and insert the result
function! InsertEmoji(emoji)
    let @a = system('cut -d " " -f 1 | emoji-fzf get', a:emoji)
    normal! "agP
endfunction

command! -bang Emoj
  \ call fzf#run({
      \ 'source': 'emoji-fzf preview',
      \ 'options': '--preview ''emoji-fzf get --name {1}''',
      \ 'sink': function('InsertEmoji')
      \ })
" Ctrl-e in normal and insert mode will open the emoji picker.
" Unfortunately doesn't bring you back to insert mode 😕
map <C-e> :Emoj<CR>
imap <C-e> <C-o><C-e>
