call plug#begin()
Plug 'chriskempson/base16-vim'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'tikhomirov/vim-glsl'
call plug#end()


let mapleader=" "
set notimeout


" Visual settings
syntax on
set background=dark
let base16colorspace=256
colorscheme base16-default-dark
hi Normal ctermbg=NONE
hi LineNr ctermbg=NONE

set number relativenumber
set nu rnu


" Editor options
set tabstop=4
set shiftwidth=4
set expandtab

set splitright

set ignorecase
set smartcase

" Clipboard
" Copy
vnoremap  <leader>y  "+y
nnoremap  <leader>Y  "+yg_
nnoremap  <leader>y  "+y
nnoremap  <leader>yy  "+yy

" Paste
nnoremap <leader>p "+p
nnoremap <leader>P "+P
vnoremap <leader>p "+p
vnoremap <leader>P "+P
