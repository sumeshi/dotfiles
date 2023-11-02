"system
syntax on
set autoread
set nobackup
set noswapfile
set noundofile
set fenc=utf-8
set nocompatible

"util
set paste

set smarttab
set autoindent
set smartindent

set hlsearch
set wrapscan
set smartcase
set incsearch
set ignorecase
nmap <Esc><Esc> :nohlsearch<CR><Esc>

set virtualedit=onemore

"override
inoremap <C-j> <Down>
inoremap <C-k> <Up>
inoremap <C-h> <Left>
inoremap <C-l> <Right>
inoremap <silent> jj <ESC>
noremap PP "0p
nnoremap j gj
nnoremap k gk
vnoremap > >gv
vnoremap < <gv

set expandtab
set tabstop=2
set shiftwidth=2
set clipboard=unnamed

"keyboard US
"nnoremap ; :
"nnoremap : ;

"view
set number
set showcmd
set showmatch
set cursorline
set laststatus=2
"set showbreak=

"graphic
set t_Co=256
set visualbell
colorscheme molokai

"commandline
set wildmode=list:longest

"command
command! -nargs=? Jq call s:Jq(<f-args>)
function! s:Jq(...)
  if 0 == a:0
	let l:arg = "."
  else
	let l:arg = a:1
  endif
  execute "%! jq \"" . l:arg . "\""
endfunction
