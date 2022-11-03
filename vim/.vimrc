" Disable compatibility with vi which can cause unexpected issues.
set nocompatible

" Enable type file detection. Vim will be able to try to detect the type of file in use.
filetype on

" Enable plugins and load plugin for the detected file type.
filetype plugin on

" Load an indent file for the detected file type.
filetype indent on

" Turn syntax highlighting on.
syntax on

" Add numbers to each line on the left-hand side.
set number

" Show line numbers relative to current line.
set relativenumber"

" Highlight cursor line underneath the cursor horizontally.
set cursorline

" Use spaces instead of tabs
set expandtab

" Be smart when using tabs ;)
set smarttab

" 1 tab == 4 spaces
set shiftwidth=4
set tabstop=4

" Do not save backup files.
set nobackup

" Ignore case when searching
set ignorecase

" When searching try to be smart about cases
set smartcase

" Show matching words during a search.
set showmatch

" Highlight search results
set hlsearch

" Makes search act like search in modern browsers
set incsearch

" Always show current position
set ruler

" Height of the command bar
set cmdheight=1

" Show partial command you type in the last line of the screen.
set showcmd

" Show the mode you are on the last line.
set showmode

" Set colour scheme.
"colorscheme mac_classic_alt
colorscheme quietlight
"set t_Co=256
"set background=light


set mouse=a
set nomodeline
