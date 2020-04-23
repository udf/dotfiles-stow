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

" Formatting rules
set encoding=utf-8
set autoindent
set tabstop=4 shiftwidth=4 expandtab


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
