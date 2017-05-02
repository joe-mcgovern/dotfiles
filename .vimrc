set number
syntax on
set tabstop=4
set shiftwidth=4
set softtabstop=4

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
set colorcolumn=80

set nocp
if exists('$DOTFILES')
    source $DOTFILES/vim/autoload/pathogen.vim
    source $DOTFILES/vim/vimrc
endif
colorscheme monokai
execute pathogen#infect()

autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
autocmd VimEnter *.js set shiftwidth=2 | set softtabstop=2 | set tabstop=2
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_python_checkers=['flake8']
let g:syntastic_loc_list_height=3

set runtimepath^=~/.vim/bundle/ctrlp.vim
let g:ctrlp_map = '<c-p>'
let g:ctrlp_by_filename = 0
set wildignore+=*/.git/*,*/.hg/*,*/.svn/*,*/cover/*

if has('nvim')
    tnoremap <Esc> <C-\><C-n>
    tnoremap jk <C-\><C-n>
    tnoremap <A-h> <C-\><C-n><C-w>h
    tnoremap <A-j> <C-\><C-n><C-w>j
    tnoremap <A-k> <C-\><C-n><C-w>k
    tnoremap <A-l> <C-\><C-n><C-w>l

    autocmd VimEnter * nested below split term://zsh
    autocmd VimEnter * resize -12
    autocmd VimEnter * set wfh
    autocmd VimEnter * wincmd k
endif

nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

set mouse-=a
