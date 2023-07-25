" Disable vi compatibility
set nocompatible

" Set UTF-8 as default encoding
filetype off
set encoding=utf-8

" Enable loading plugin files
filetype indent plugin on

" Syntax highlighting
syntax on

" Disable q! to override message
set hidden

" Enable prompt to save modified file
set confirm

" Tabs
set tabstop=4
set softtabstop=4
set shiftwidth=4

" Line numbering
set number

" Force show command-line on the bottom
set showcmd

" Enable auto-complete for commands
set wildmenu

" Highlight matching brackets
set showmatch

" Highlight search
set incsearch
set hlsearch

" Lower-case = case-insensitive search
set ignorecase
set smartcase

" Normal backspace behaviour
set backspace=indent,eol,start

" Copy indentation of current line to new line
set autoindent

" Don't go to start of line when jumping
set nostartofline

" Show cursor position
set ruler

" Always show statusline
set laststatus=2

" Number of lines for messages
set cmdheight=2

" Clear search highlighting with CTRL+L
nnoremap <C-L> :nohl<CR><C-L>

" Set hotkey for paste mode
set pastetoggle=<F2>

" Configure indent-based folding
" set foldmethod=indent
" set foldlevel=0
" set foldclose=all

" Disable .viminfo file
set viminfofile=NONE

