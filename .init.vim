call plug#begin()

" Color Schemes
Plug 'jfecher/vim-sunset-theme'
Plug 'gruvbox-community/gruvbox'

" UI
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'folke/which-key.nvim'
Plug 'norcalli/nvim-colorizer.lua'

" Navigation
" Plug 'ctrlpvim/ctrlp.vim'
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'

" LSP & Language-specific
Plug 'Saghen/blink.cmp'
Plug 'neovim/nvim-lspconfig'
Plug 'noir-lang/noir-nvim'
Plug 'jfecher/ante.vim'

" Other
Plug 'romainl/vim-cool'
Plug 'tpope/vim-fugitive'

call plug#end()

color sunset

" Load lsp.lua config file
runtime lsp.lua

""""" Here begins the great wall of heretic remaps. Look away, those of faint heart!"""
" Heresy 1: Use ijkl for movement
nnoremap i k
nnoremap k j
nnoremap j h

vnoremap i k
vnoremap k j
vnoremap j h

nmap <silent><C-w>j <C-w>h
nmap <silent><C-w>i <C-w>j
nmap <silent><C-w>J <C-w>H

nmap <silent><C-w>I <C-w>J
nmap <silent><C-w>j <C-w>h
nmap <silent><C-w>i <C-w>j

" bind C-movement key to switch to a different split
nnoremap <silent><C-j> <C-w>h
nnoremap <silent><C-i> <C-w>k
nnoremap <silent><C-k> <C-w>j
nnoremap <silent><C-l> <C-w>l

inoremap <silent><C-j> <Esc><C-w>h
inoremap <silent><C-i> <Esc><C-w>k
inoremap <silent><C-k> <Esc><C-w>j
inoremap <silent><C-l> <Esc><C-w>l

" Heresy 2: Use h for insertion
nnoremap h i

" Heresy 3: Use `;` for commands
nnoremap ; :

" Heresy 4: Use `jj` to get out of insert mode
inoremap jj <Esc>
tnoremap jj <C-\><C-n>

" Use `C-t` for :terminal
nmap <silent>t :terminal<CR>h
" tnoremap <Esc> <C-\><C-n>

" Use space for leader
let mapleader = "\<Space>"
nnoremap <Leader>a :echo "hey there"<CR>

""""""""""""""""""""""""""""""""" Options """""""""""""""""""""""""""""
set nowrap
set number

" No extra files
set nobackup
set nowritebackup
set noswapfile

" Ignore some common paths & binary files
set wildignore+=*/.git/*,*/.hg/*,*/.svn/*,*.so,*.cbp,*/target/*
set wildignore+=*.o,*.ao,*.d,*.gch,*.class,*.obj,*/build/*

""""""""""""""""""""""""""" LSP bindings """""""""""""""""""""""""""""""
" Shorter command for code actions
nmap ga gra

"""""""""""""""""""""""" Plugin-specific config """"""""""""""""""""""""
""" Airline
let g:airline#extensions#tabline#enabled = 1

""" FZF
let $FZF_DEFAULT_COMMAND = 'fd'
nnoremap <C-p> <cmd>Files<CR>
nnoremap <Leader>/ <cmd>Rg<CR>

""" Which-key
nnoremap <silent><Leader> <cmd>WhichKey<CR>
