set relativenumber
set number
set encoding=utf-8
scriptencoding utf-8
set tabstop=4
set shiftwidth=4
set softtabstop=4
set ignorecase
set tags=./tags;
set hidden
" Enter normal mode (from insert mode) by typing jk
inoremap jk <ESC>
let mapleader=","
set encoding=utf-8
set expandtab
set wrap
set linebreak

let python="/usr/bin/python"
let python3="/usr/local/bin/python3"

" Open vimrc for editing using `ev`
nnoremap ev :e $MYVIMRC<CR>
" Reload vimrc using `rv`
nnoremap rv :w!<Esc>:source $MYVIMRC<CR>

" Decrease window size
nnoremap <Leader><C-k> :resize -5<CR>
" Increase window size
nnoremap <Leader><C-j> :resize +5<CR>

" Add keybindings for terminal mode
tnoremap <Esc> <C-\><C-n>
tnoremap jk <C-\><C-n>
tnoremap <C-h> <C-\><C-n><C-w>h
tnoremap <C-j> <C-\><C-n><C-w>j
tnoremap <C-k> <C-\><C-n><C-w>k
tnoremap <C-l> <C-\><C-n><C-w>l

nnoremap tn :TestNearest<CR>
nnoremap tt  :NERDTreeToggle<CR>
nnoremap <Leader>b :buffers<CR>:buffer<Space>
map fz :Files<CR>
set clipboard=unnamed
set colorcolumn=79

set nocp
if exists('$DOTFILES')
    source $DOTFILES/vim/autoload/pathogen.vim
    source $DOTFILES/vim/vimrc
endif
filetype off

let g:ale_linters = {
            \    'python': ['pyls'],
            \    'javascript': ['jshint'],
            \    'go': ['gopls'],
            \    'rust': ['rls'],
            \}
let g:ale_fixers = {
            \    'rust': ['rustfmt'],
            \    'python': ['black', 'isort'],
            \}
let g:ale_completion_enabled = 1
let g:ale_completion_delay = 100
let g:ale_fix_on_save = 1
let g:ale_lint_delay = 100
let g:ale_lint_on_enter = 1
let g:ale_lint_on_save = 1
" Only run linters named in ale_linters settings.
let g:ale_linters_explicit = 1
nmap <silent> <C-k> <Plug>(ale_previous_wrap)
nmap <silent> <C-j> <Plug>(ale_next_wrap)
let g:ale_lint_on_text_changed = 0
let g:ale_set_loclist = 1
let g:ale_set_quickfix = 0
let g:ale_open_list = 1
let g:ale_list_window_size = 3
let g:ale_virtual_env_dir_names = [$VIRTUAL_ENV]
let g:rustfmt_autosave = 1
" Have clicking tab and shift-tab cycle through autocomplete suggestions
inoremap <silent><expr> <Tab> pumvisible() ? "\<C-n>" : "\<TAB>"
inoremap <silent><expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-TAB>"

let g:zettel_fzf_command = "rg"
let g:zettel_format = "%y/%m/%d-%H:%M-%title.md"
let g:zettel_random_chars = 1
set rtp+=/usr/local/opt/fzf

" add ~/.vim to the packpath so windows works like linux
set packpath^=~/.vim
set runtimepath^=~/.vim

execute pathogen#infect()
execute pathogen#helptags()

syntax on
filetype plugin indent on
set nocompatible

autocmd StdinReadPre * let s:std_in=1
autocmd BufReadPre *.js set shiftwidth=2 | set softtabstop=2 | set tabstop=2
autocmd BufReadPre *.jsx set shiftwidth=2 | set softtabstop=2 | set tabstop=2
autocmd BufReadPre *.yaml set shiftwidth=2 | set softtabstop=2 | set tabstop=2 expandtab
autocmd BufReadPre *.html set shiftwidth=2 | set softtabstop=2 | set tabstop=2
autocmd BufReadPre *.go set shiftwidth=2 expandtab | set softtabstop=2 expandtab | set tabstop=2 expandtab
" 50 for subject, 72 for body
autocmd BufReadPre  *COMMIT_EDITMSG set colorcolumn=50,72
autocmd WinEnter *zsh resize 12

set runtimepath^=~/.vim/bundle/ctrlp.vim
let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlPLastMode'
let g:ctrlp_by_filename = 0
let g:ctrlp_extensions = ['line']
set wildignore+=*/.git/*,*/.hg/*,*/.svn/*,*/cover/*,*/node_modules/*,*.pyc,*/venv/*,*/lib/*,*src/static/*

if has('nvim')
    tnoremap <Esc> <C-\><C-n>
    tnoremap jk <C-\><C-n>
    tnoremap <A-h> <C-\><C-n><C-w>h
    tnoremap <A-j> <C-\><C-n><C-w>j
    tnoremap <A-k> <C-\><C-n><C-w>k
    tnoremap <A-l> <C-\><C-n><C-w>l
else
    set term=screen-256color
endif

nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
cnoreabbrev Ag Ag!
cnoreabbrev Greadm Gread master:%
nnoremap <Leader>a :Ag!<Space>

map <F5>    :ImportName<CR>
map <C-F5>  :ImportNameHere<CR>

let g:EasyMotion_do_mapping = 0 " Disable default mappings

" Jump to anywhere you want with minimal keystrokes, with just one key
" binding.
" `s{char}{label}`
nmap s <Plug>(easymotion-overwin-f)
let g:EasyMotion_smartcase = 1
function! s:config_easyfuzzymotion(...) abort
      return extend(copy({
        \   'converters': [incsearch#config#fuzzyword#converter()],
        \   'modules': [incsearch#config#easymotion#module({'overwin': 1})],
        \   'keymap': {"\<CR>": '<Over>(easymotion)'},
        \   'is_expr': 0,
        \   'is_stay': 1
        \ }), get(a:, 1, {}))
endfunction

noremap <silent><expr> <Leader>/ incsearch#go(<SID>config_easyfuzzymotion())

" Enable mouse-clicking
" set mouse=a

let g:NERDSpaceDelims = 1

" Dont show scratch preview for autocomplete
" set completeopt-=preview
set completeopt=menu,menuone,preview,noselect,noinsert

let g:easytags_dynamic_files = 1
let g:easytages_syntax_keyword = 'always'
let g:easytags_async = 1
let g:easytags_auto_highlight=0
let g:ycm_collect_identifiers_from_tags_files=0

let g:autoflake_remove_all_unused_imports=1
let g:autoflake_disable_show_diff=1

set laststatus=2
set noshowmode
colorscheme monokai
let g:lightline = {
  \     'active': {
  \         'left': [['mode', 'paste' ], ['gitbranch', 'readonly', 'relativepath', 'modified']],
  \         'right': [[ 'linter_checking', 'linter_errors', 'linter_warnings', 'linter_ok' ]]
  \     },
  \     'component_function': {
  \         'gitbranch': 'fugitive#head',
  \     },
  \ }
let g:lightline.component_expand = {
      \  'linter_checking': 'lightline#ale#checking',
      \  'linter_warnings': 'lightline#ale#warnings',
      \  'linter_errors': 'lightline#ale#errors',
      \  'linter_ok': 'lightline#ale#ok',
      \ }
let g:lightline.component_type = {
      \     'linter_checking': 'left',
      \     'linter_warnings': 'warning',
      \     'linter_errors': 'error',
      \     'linter_ok': 'left',
      \ }
" let g:lightline.active = { 'right': [[ 'linter_checking', 'linter_errors', 'linter_warnings', 'linter_ok' ]] }
let g:fzf_nvim_statusline = 0 " disable statusline overwriting

let test#strategy = "neovim"
" let test#python#runner = 'nose'
let g:test#preserve_screen = 1

let g:go_highlight_build_constraints = 1
let g:go_highlight_extra_types = 1
let g:go_highlight_fields = 1
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_operators = 1
let g:go_highlight_structs = 1
let g:go_highlight_types = 1
let g:go_auto_sameids = 1
let g:ale_sign_error = '⤫'
let g:ale_sign_warning = '⚠'
let g:airline#extensions#ale#enabled = 1
let g:go_imports_autosave = 1
" Let ALE handle code completion, definitions, etc
" let g:go_gopls_enabled = 1
" let g:go_def_mode = 1
" let g:go_code_completion_enabled = 0
" let g:go_meta_linter_enabled = 0

" Don't let startify change the directory
let g:startify_change_to_dir = 0

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
      \ 'src/lib', 'src/static',
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

" Only files in the wiki directory should have a vimwiki filetype
let g:vimwiki_global_ext = 0
let g:vimwiki_option_syntax = 'markdown'
let g:vimwiki_list = [
    \ {'path': '~/vimwiki/', 'syntax': 'markdown', 'ext': '.md', 'links_space_char': '-'},
    \ ]

" Automatically close quickfix/loclist when main buffer is closed
autocmd WinEnter * if &buftype ==# 'quickfix' && winnr('$') == 1 | quit | endif

" Automatically enable spell check on markdown and git commit files
autocmd FileType markdown setlocal spell
autocmd FileType gitcommit setlocal spell
autocmd FileType markdown setlocal complete+=kspell
autocmd FileType gitcommit setlocal complete+=kspell

nmap <Space>r :call feedkeys(":Rename " . expand('%@'))<CR>

function StripTrailingWhitespace ()
    " don't strip on these filetypes
    if &ft =~ 'markdown'
        return
    endif
    %s/\s\+$//e
endfunction

autocmd BufWritePre * call StripTrailingWhitespace()

" Transparent editing of gpg encrypted files.
" By Wouter Hanegraaff
augroup encrypted
  au!

  " First make sure nothing is written to ~/.viminfo while editing
  " an encrypted file.
  autocmd BufReadPre,FileReadPre *.gpg set viminfo=
  " We don't want a various options which write unencrypted data to disk
  autocmd BufReadPre,FileReadPre *.gpg set noswapfile noundofile nobackup

  " Switch to binary mode to read the encrypted file
  autocmd BufReadPre,FileReadPre *.gpg set bin
  autocmd BufReadPre,FileReadPre *.gpg let ch_save = &ch|set ch=2
  " (If you use tcsh, you may need to alter this line.)
  autocmd BufReadPost,FileReadPost *.gpg '[,']!gpg --decrypt 2> /dev/null

  " Switch to normal mode for editing
  autocmd BufReadPost,FileReadPost *.gpg set nobin
  autocmd BufReadPost,FileReadPost *.gpg let &ch = ch_save|unlet ch_save
  autocmd BufReadPost,FileReadPost *.gpg execute ":doautocmd BufReadPost " . expand("%:r")

  " Convert all text to encrypted text before writing
  " (If you use tcsh, you may need to alter this line.)
  autocmd BufWritePre,FileWritePre *.gpg '[,']!gpg --default-recipient-self -ae 2>/dev/null
  " Undo the encryption so we are back in the normal text, directly
  " after the file has been written.
  autocmd BufWritePost,FileWritePost *.gpg u
augroup END
