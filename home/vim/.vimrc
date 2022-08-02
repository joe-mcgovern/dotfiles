" Use za in normal mode to unfold any section
" Use zR to expand all folds
" Use zM to close all folds
"
" Currently using ALE to make vim act like an IDE for python, and Coc for
" everything else. Unfortunately, Coc doesn't have a plugin that respects
" virtualenvs, which every project I work on uses. I also wasn't able to find
" an easy way to enable isort and black.
"
" Basic settings ---------------------- {{{

" Configure python to be python3
set pyxversion=3

" Show number of matching results in buffer when searching
set shortmess-=S

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

" Set syntax theme to gruvbox. Vim has some built in schemes, but
" custom ones can be added via the ~/.vim/colors directory
" The lines above the colorscheme declaration are necessary for the specific
" gruvbox theme to work in vim + tmux
let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
set termguicolors
set background=dark
colorscheme gruvbox

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

" Configure file explorer
let g:netrw_banner = 0
let g:netrw_liststyle = 3
let g:netrw_browse_split = 4
let g:netrw_altv = 1
let g:netrw_winsize = 15

" Use easier diffing algorithm for vimdiff
if has("patch-8.1.0360")
  set diffopt+=internal,algorithm:patience
endif

" Safe editing ----- {{{
"
" Thanks to https://begriffs.com/posts/2019-07-19-history-use-vim.html
" Protect changes between writes. Default values of
" updatecount (200 keystrokes) and updatetime
" (4 seconds) are fine
set swapfile
set directory^=~/.vim/swap//

" protect against crash-during-write
set writebackup
" but do not persist backup after successful write
set nobackup
" use rename-and-write-new method whenever safe
set backupcopy=auto
if has("patch-8.1.0251")
	" consolidate the writebackups -- not a big
	" deal either way, since they usually get deleted
	set backupdir^=~/.vim/backup//
end

" save undo trees in files
set undofile
set undodir=~/.vim/undo

" number of undo saved
set undolevels=10000

" }}}

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
nnoremap <C-]> :keepjumps ALEGoToDefinition<CR>

augroup help_jump
  autocmd!
  autocmd FileType help nnoremap <C-]> :silent execute "tag " . substitute(expand("<cWORD>"), "\|", "", "g")<CR>zz
augroup END

" Use <Leader>I to attempt to import the word under cursor
nnoremap <Leader>I :ALEImport<CR>

" Use <Leader>u to toggle the undo tree
nnoremap <Leader>u :UndotreeToggle<CR>

" Open up the list of buffers using fzf
nnoremap <Leader>b :Buffers<CR>

" Explore the file tree
nnoremap <Leader>e :Lexplore<CR>

" Start fzf using fz
nnoremap fz :Files<CR>

" Use Control-d to delete the current line in insert mode
inoremap <C-d> <esc>dd$a

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

" Filetype specific mappings ---------------------- {{{

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

" vim {{{
"
" Replace hashtags with double quotes for vimrc files
" Temporarily disabling this because vim9 functions use hashtag comments
" function ReplaceStartingHashtagsWithDoubleQuotes ()
"   %s/^\(\s*\)#/\1"/e
" endfunction

augroup filetype_vim
  autocmd!
  autocmd FileType vim setlocal foldmethod=marker foldlevelstart=0 shiftwidth=2 tabstop=2
  autocmd Filetype vim iabbrev <buffer> == ==#
  " autocmd BufWritePre *.vimrc call ReplaceStartingHashtagsWithDoubleQuotes()
augroup END
" }}}
" }}}

" Status line ---------------------- {{{
" Configure status line
let g:lightline = {
  \     'active': {
  \         'left': [['mode', 'paste' ], ['cocstatus', 'gitbranch', 'readonly', 'cwd', 'relativepath', 'modified']],
  \     },
  \     'component_function': {
  \         'gitbranch': 'fugitive#head',
  \         'cocstatus': 'coc#status',
  \         'cwd': 'LightlineCwd',
  \     },
  \ }


function LightlineCwd()
  " Remove $HOME from current working directory
  let l:path_without_home = substitute(getcwd(), $HOME . "/", "", "")
  " If the directory is nested within some kind of dev directory, remove the
  " dev directory from the path as well
  return substitute(l:path_without_home, "^[a-zA-Z]*dev/", "", "i")
endfunction

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

let g:terraform_fmt_on_save = 1

" Undotree ----------------- {{{
let g:undotree_SetFocusWhenToggle = 1
" }}}

" FZF ---------------------- {{{

function! s:build_quickfix_list(lines)
  call setqflist(map(copy(a:lines), '{ "filename": v:val }'))
  copen
  cc
endfunction


" Insert a markdown link for all selected files
function! s:insert_link(lines)
  let l:links = []

  for l:line in a:lines
    let l:fname_wo_date = substitute(l:line, '[0-9]\+\-', '', '')
    let l:fname_wo_ext = substitute(l:fname_wo_date, '\..*$', '', '')
    let l:fname_wo_hyphens = substitute(l:fname_wo_ext, '\-', ' ', 'g')
    let l:links = add(l:links, "[" . l:fname_wo_hyphens . "](" . l:line . ")")
  endfor
  echom l:links
  " Must declare a variable here so that vim can open without complaining.
  let l:failed = append(line("."), l:links)
endfunction

let g:fzf_action = {
  \ 'ctrl-q': function('s:build_quickfix_list'),
  \ 'ctrl-l': function('s:insert_link'),
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
let g:ale_linters = {
            \    'go': ['gopls'],
            \    'python': ['pylsp'],
            \    'typescript': ['eslint', 'tsserver'],
            \    'typescriptreact': ['eslint', 'tsserver'],
            \    'javascript': ['eslint', 'tsserver'],
            \    'javascriptreact': ['eslint', 'tsserver'],
            \    'terraform': ['terraform'],
            \}

let g:ale_fixers = {
            \    'go': ['goimports', 'remove_trailing_lines', 'trim_whitespace'],
            \    'python': ['autoflake', 'isort', 'black', 'remove_trailing_lines', 'trim_whitespace'],
            \    'typescript': ['prettier', 'remove_trailing_lines', 'trim_whitespace'],
            \    'typescriptreact': ['prettier', 'remove_trailing_lines', 'trim_whitespace'],
            \    'javascript': ['prettier', 'remove_trailing_lines', 'trim_whitespace'],
            \    'javascriptreact': ['prettier', 'remove_trailing_lines', 'trim_whitespace'],
            \    'terraform': ['terraform', 'remove_trailing_lines', 'trim_whitespace'],
            \}
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
let g:ale_python_auto_pipenv = 1
let g:ale_python_auto_poetry = 1
let g:ale_python_black_auto_pipenv = 1
let g:ale_python_black_auto_poetry = 1
let g:ale_python_isort_auto_pipenv = 1
let g:ale_python_isort_auto_poetry = 1
let g:ale_completion_enabled = 1

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
" inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
"                               \: '\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>'

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
"
" emoji-fzf -------- {{{
" Use emoji-fzf and fzf to fuzzy-search for emoji, and insert the result
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


" Custom zettel plugin --- {{{

let g:zettelkasten = "~/zettel/"

def ZettelNew(name: string)
  const clean_name = join(split(name, " "), "-")
  const fname = g:zettelkasten .. strftime("%Y%m%d%H%M") .. "-" .. clean_name .. ".md"
  execute ":edit " .. fname
  const failed = setline(".", "# " .. name)
enddef

command! -nargs=0 ZettelHome :silent execute "edit " . g:zettelkasten . "index.md"
command! -nargs=1 ZettelNew :call ZettelNew(<f-args>)

nnoremap <leader>zn :ZettelNew
nnoremap <leader>zh :ZettelHome<cr>
" }}}
