set number
syntax on
set tabstop=4
set shiftwidth=4
set softtabstop=4
set laststatus=2
set statusline+=%F
set statusline+=%{fugitive#statusline()}
set tags=tags;/

inoremap jk <ESC>
let mapleader="\<Space>"
set encoding=utf-8
set expandtab
filetype plugin indent on
set wrap
set linebreak
" note trailing space at end of next line
" set showbreak=>\ \ \
autocmd BufWritePre * %s/\s\+$//e
nnoremap th  :tabfirst<CR>
nnoremap tp  :tabprev<CR>
nnoremap tl  :tablast<CR>
nnoremap tn  :tabnext<CR>
nnoremap td  :tabclose<CR>
nnoremap tc  :tabedit<Space>
nnoremap tt  :NERDTreeToggle<CR>
nnoremap <leader>. :CtrlPTag<cr>
set clipboard=unnamed
set colorcolumn=80

set nocp
if exists('$DOTFILES')
    source $DOTFILES/vim/autoload/pathogen.vim
    source $DOTFILES/vim/vimrc
endif
colorscheme monokai
execute pathogen#infect()

autocmd StdinReadPre * let s:std_in=1
" autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
autocmd BufReadPre *.js set shiftwidth=2 | set softtabstop=2 | set tabstop=2
autocmd BufReadPre *.jsx set shiftwidth=2 | set softtabstop=2 | set tabstop=2
autocmd BufReadPre *.yaml set shiftwidth=2 | set softtabstop=2 | set tabstop=2
autocmd BufReadPre *.html set shiftwidth=2 | set softtabstop=2 | set tabstop=2
autocmd WinEnter *zsh resize 12

set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_python_checkers=['flake8']
let g:syntastic_loc_list_height=3
let g:airline_theme='base16'

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
nnoremap <Leader>a :Ag!<Space>

let g:EasyMotion_do_mapping = 0 " Disable default mappings

" Jump to anywhere you want with minimal keystrokes, with just one key
" binding.
" " `s{char}{label}`
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

noremap <silent><expr> / incsearch#go(<SID>config_easyfuzzymotion())

set mouse=a

let g:NERDSpaceDelims = 1

" Dont show scratch preview for autocomplete
set completeopt-=preview

let g:easytags_dynamic_files = 1
let g:easytags_async = 1
let g:easytages_syntax_keyword = 'always'
autocmd FileType python let b:easytags_auto_highlight = 0
