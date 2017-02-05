set number
syntax on
set tabstop=2
set shiftwidth=2
set softtabstop=2
inoremap jk <ESC>
set shiftwidth=4
let mapleader = "\<Space>"
set softtabstop=4
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
set colorcolumn=80
