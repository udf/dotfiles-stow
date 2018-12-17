call plug#begin()
Plug 'chriskempson/base16-vim'
call plug#end()

syntax on
set background=dark
let base16colorspace=256
colorscheme base16-default-dark
hi Normal ctermbg=NONE
hi LineNr ctermbg=NONE

set number relativenumber
set nu rnu

set tabstop=4
set shiftwidth=4
set expandtab

set splitright

set ignorecase
set smartcase
