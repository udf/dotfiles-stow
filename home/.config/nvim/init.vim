call plug#begin()

" Visuals
Plug 'chriskempson/base16-vim'
"Plug 'vim-airline/vim-airline'
"Plug 'vim-airline/vim-airline-themes'
"Plug 'Yggdroot/indentLine'
"Plug 'airblade/vim-gitgutter'

" Search
"Plug 'haya14busa/is.vim'
"Plug 'haya14busa/vim-asterisk'
"Plug 'mileszs/ack.vim'

" Misc
"Plug 'tpope/vim-sleuth'
"Plug 'majutsushi/tagbar'
"Plug 'sjl/gundo.vim'

" Editing
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'

" Language support
Plug 'tikhomirov/vim-glsl'
"Plug 'mitsuhiko/vim-jinja'
"Plug 'rust-lang/rust.vim'
"Plug 'cespare/vim-toml'

" Code completion
"Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
"Plug 'Shougo/echodoc.vim'
"Plug 'autozimu/LanguageClient-neovim', {
"    \ 'branch': 'next',
"    \ 'do': 'bash install.sh',
"    \ }

Plug 'lilydjwg/colorizer'

call plug#end()

" General settings
let mapleader=" "
set notimeout "stop leader (and other keys) from timing out
set mouse=a
set wildmode=longest,list,full
set wildmenu
set splitright splitbelow
set ignorecase smartcase
set gdefault
inoremap <expr> <CR> pumvisible() ? "\<C-Y>" : "\<CR>"


" Editor look
set nowrap
set scrolloff=5
set sidescrolloff=10
set number relativenumber
set nu rnu
set cursorline
set colorcolumn=+1
set list listchars=tab:\ \ ,trail:•,precedes:…,extends:…
set signcolumn=yes


" Syntax highlighting
syntax on
set synmaxcol=1024
set background=dark
let base16colorspace=256
colorscheme base16-default-dark
hi Normal ctermbg=NONE
hi LineNr ctermbg=NONE


" Formatting rules
set encoding=utf-8
set autoindent
set tabstop=4 shiftwidth=4 expandtab
"set cino=:0 TODO: figure out what i like here
"setlocal textwidth=100
" au FileType text,markdown setlocal textwidth=80
" au FileType python setlocal textwidth=79
" Trim trailing spaces
nnoremap <silent> <F5> :let _s=@/<Bar>:%s/\s\+$//e<Bar>:let @/=_s<Bar>:nohl<CR>


" Leader Bindings
" System Clipboard
" Copy
vnoremap <leader>y "+y
nnoremap <leader>Y "+yg_
nnoremap <leader>y "+y
nnoremap <leader>yy "+yy
" Paste
nnoremap <leader>p "+p
nnoremap <leader>P "+P
vnoremap <leader>p "+p
vnoremap <leader>P "+P


" Misc bindings
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
nnoremap <silent> <C-t> :tabnew<CR>
nnoremap <silent> <C-n> :tabnext<CR>
nnoremap <silent> <C-p> :tabprevious<CR>
nnoremap <C-[> <C-t>
noremap ; :
" Clear search highligting
nnoremap <silent> <C-L> :nohlsearch<CR><C-L>
" recursive vimgrep
nnoremap <leader>s :vimgrep // **/*<left><left><left><left><left><left>
