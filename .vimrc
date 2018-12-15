" Basic options
set nocompatible
set number
set laststatus=2
set noshowmode
set nostartofline
set wildmenu
set encoding=utf8
set background=dark
set nowrap
set cursorline
set noswapfile
set nobackup

" Completion
set completeopt=menuone,preview,noinsert,noselect

" Viewing and getting around
set sidescroll=1
set sidescrolloff=5
set scrolloff=5
set splitbelow
set splitright
set ttimeoutlen=10
set foldmethod=syntax
set list
set listchars=tab:\|\ 
set linebreak
set colorcolumn=80
set t_Co=256

" Tabbing and indentation
set noexpandtab
set tabstop=4
set shiftwidth=4
set softtabstop=4

if (empty($TMUX))
	if (has("nvim"))
		let $NVIM_TUI_ENABLE_TRUE_COLOR=1
	endif
	if (has("termguicolors"))
		set termguicolors
	endif
endif

autocmd VimEnter * call SetCDToGitRoot()

" -------------------------------------------------------------"
" vim-plug
" -------------------------------------------------------------"
" Plugin loading and handling
if empty(glob('~/.vim/autoload/plug.vim'))
	silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
		\ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
	autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/bundle')
Plug 'davidhalter/jedi-vim', {'for': 'python'}
if (has('nvim'))
	Plug 'Shougo/deoplete.nvim', {'do': ':UpdateRemotePlugins'}
	Plug 'zchee/deoplete-jedi', {'for': 'python'}
else
	Plug 'Shougo/deoplete.nvim'
	Plug 'roxma/nvim-yarp'
	Plug 'roxma/vim-hug-neovim-rpc'
endif
Plug 'carlitux/deoplete-ternjs', {'for': 'js'}
Plug 'Shougo/neco-syntax'
Plug 'Shougo/neco-vim', {'for': 'vim'}
Plug 'raimondi/delimitMate'
Plug 'scrooloose/nerdcommenter'
Plug 'nathanblair/vim-dracula-theme' ", {'as': 'vim-dracula-theme'}
Plug 'mhinz/vim-signify'
Plug 'tpope/vim-fugitive'
Plug 'junegunn/gv.vim'
Plug 'mattn/emmet-vim', {'for': 'html'}
call plug#end()

" -------------------------------------------------------------"
" vim-plug settings
" -------------------------------------------------
" Signify
let g:signify_vcs_list=['git']

" Deoplete
let g:deoplete#enable_at_startup=1

" DelimitMate
let delimitMate_expand_cr=1
let delimitMate_expand_space=1
let delimitMate_jump_expansion=1

" Vim colorscheme
color dracula

" -------------------------------------------------------------"
" Language settings
" -------------------------------------------------------------"
" Python
let g:deoplete#sources#jedi#show_docstring=1


" -------------------------------------------------------------"
" keymaps
" -------------------------------------------------
" Folding and leader remaps
nnoremap ; za
nmap <Space> \

" Exit vim
nnoremap <silent> <Leader>q :qa<CR>

" Edit vim config file
nnoremap <silent> <Leader>vim :e! ~/.vimrc<CR>

" Swap lines
nnoremap <silent> <A-j> :m+1<CR>
nnoremap <silent> <A-k> :m-2<CR>

" Move around windows
nnoremap <silent> <Leader>h <C-w>h
nnoremap <silent> <Leader>j <C-w>j
nnoremap <silent> <Leader>k <C-w>k
nnoremap <silent> <Leader>l <C-w>l

" Cycle between buffers and close them
nnoremap <silent> <Tab> :bn!<CR>
nnoremap <silent> <S-Tab> :bp!<CR>
nnoremap <silent> <Leader>d :bp!\|bd #<CR>
nnoremap <silent> <Leader>D :bd<CR>
nnoremap <silent> <Leader>p :pc<CR>

" Scroll page with arrow keys
nnoremap <silent> <Down> <C-e>
nnoremap <silent> <Up> <C-y>

" Add lines above and below
nnoremap <silent> J mGo<ESC>`G
nnoremap <silent> K mGO<ESC>`G

" Join lines
nnoremap <silent> <C-j> :join<CR>

" Source file
nnoremap <silent> <Leader>r :source ~/.vimrc<CR>

" Highlight and searching
nnoremap <silent> <Leader>n :noh<CR>

" Make ctrl-backspace work like all other editors
noremap <C-BS> <C-w>

" Substitute
nnoremap <Leader>s :%s/

" Write buffer to filesystem
nnoremap <silent> <Leader>w :w<CR>

" Simple vim fuzzy search
nnoremap <Leader>f :f **/*
nnoremap <Leader>e :e **/*
nnoremap <Leader>v :vs **/*

" Tab completion
inoremap <expr><Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr><S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

" -------------------------------------------------------------"
" vim-plug keymaps
" -------------------------------------------------
" Commenting
imap <C-c> <plug>NERDCommenterInsert


" -------------------------------------------------------------"
" Statusbar
" -------------------------------------------------
"  Left-align
set statusline=
set statusline+=\ \ %{GetMode()}\ \ 
set statusline+=%#Normal#\ \ %t
set statusline+=%(\ %r%h%w%)
set statusline+=\ %m\ 
set statusline+=%#IncSearch#\ 
set statusline+=%{GetGit()}\ 

" Center
set statusline+=%#LineNr#

" Right-align
set statusline+=%=\ %#Visual#
set statusline+=\ %y
set statusline+=\ %#QuickFixLine#\ %{&fileencoding}
set statusline+=\ %#Include#\ [%{&fileformat}]
set statusline+=\ %L\ 


" -------------------------------------------------------------"
" Helper functions
" -------------------------------------------------
function! SetCDToGitRoot()
	let l:dir_path = system("git rev-parse --git-dir &>/dev/null") ?
				   \ system("git rev-parse --show-top-level") : expand('%:p:h')
	lcd `=l:dir_path`
endfunction

function! GetGit()
	
	return "master"
endfunction

function! GetMode()
	let l:mode = mode()
	" Transpose l:mode into desired text
	" TODO

	" Apply color to mode
	" TODO

	return l:mode
endfunction

