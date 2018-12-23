" Basic options
set number
set nocompatible
set laststatus=2
set noshowmode
set wildmenu
set encoding=utf8
set background=dark
set nowrap
set cursorline
set noswapfile
set nobackup

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
set colorcolumn=81
set t_Co=256

" Tabbing and indentation
set noexpandtab
set tabstop=4
set shiftwidth=4
set softtabstop=4

" Completion
set completeopt=menuone,preview,noinsert,noselect

autocmd BufEnter * call s:CDToGitRoot()

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
	Plug 'Shougo/neco-syntax'
	Plug 'Shougo/neco-vim', {'for': 'vim'}
endif
Plug 'carlitux/deoplete-ternjs', {'for': 'js'}
Plug 'raimondi/delimitMate'
Plug 'scrooloose/nerdcommenter'
Plug 'nathanblair/vim-dracula-theme' , {'as': 'vim-dracula-theme'}
Plug 'mhinz/vim-signify'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'
Plug 'junegunn/gv.vim'
Plug 'mattn/emmet-vim', {'for': 'html'}
call plug#end()

" Vim colorscheme
if (empty($TMUX))
	if (has("nvim"))
		let $NVIM_TUI_ENABLE_TRUE_COLOR=1
	endif
	if (has("termguicolors"))
		set termguicolors
	endif
endif

color dracula
hi Normal guibg=NONE ctermbg=NONE


" -------------------------------------------------------------"
" vim-plug settings
" -------------------------------------------------------------"
" Signify
let g:signify_vcs_list=['git']

" Deoplete
let g:deoplete#enable_at_startup=1

" DelimitMate
let delimitMate_expand_cr=1
let delimitMate_expand_space=1
let delimitMate_jump_expansion=1


" -------------------------------------------------------------"
" Language settings
" -------------------------------------------------------------"
" Python
let g:deoplete#sources#jedi#show_docstring=1


" -------------------------------------------------------------"
" keymaps
" -------------------------------------------------------------"
" Edit vim config file
nnoremap <silent> <Leader>vim :e! ~/.vimrc<CR>

" Source file
nnoremap <silent> <Leader>r :source ~/.vimrc<CR>

" Folding and leader remaps
nnoremap ; za
nmap <Space> \

" Write buffer to filesystem
nnoremap <silent> <Leader>w :w<CR>

" Exit vim
nnoremap <silent> <Leader>Q :qa<CR>

" Substitute
nnoremap <Leader>s :%s/

" Highlight and searching
nnoremap <silent> <Leader>n :noh<CR>

" Join lines
nnoremap <silent> <C-j> :join<CR>

" Swap lines
nnoremap <silent> <A-j> :m+1<CR>
nnoremap <silent> <A-k> :m-2<CR>

" Add lines above and below
nnoremap <silent> J mGo<ESC>`G
nnoremap <silent> K mGO<ESC>`G

" Cycle between buffers and close them
nnoremap <silent> <Tab> :bn!<CR>
nnoremap <silent> <S-Tab> :bp!<CR>
nnoremap <silent> <Leader>d :bp!\|bd #<CR>
nnoremap <silent> <Leader>D :bd<CR>
nnoremap <silent> <Leader>p :pc<CR>
nnoremap <silent> <Leader>q :q<CR>

" Move around windows
nnoremap <silent> <Leader>h <C-w>h
nnoremap <silent> <Leader>j <C-w>j
nnoremap <silent> <Leader>k <C-w>k
nnoremap <silent> <Leader>l <C-w>l

" Scroll page with arrow keys
nnoremap <silent> <Down> <C-e>
nnoremap <silent> <Up> <C-y>

" Simple vim fuzzy search
nnoremap <Leader>f :f **/*
nnoremap <Leader>e :e **/*
nnoremap <Leader>v :vs **/*

" Tab completion
inoremap <expr><Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr><S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"


" -------------------------------------------------------------"
" vim-plug keymaps
" -------------------------------------------------------------"
" Commenting
imap <C-c> <plug>NERDCommenterInsert


" -------------------------------------------------------------"
" Statusbar
" -------------------------------------------------------------"
set statusline=
set statusline+=%{LeftStatusline()}
"set statusline+=%!SetCenterBarColor()
set statusline+=%=
set statusline+=%{RightStatusLine()}
set statusline+=%*

" -------------------------------------------------------------"
" Helper functions
" -------------------------------------------------------------"
function! s:CDToGitRoot() abort
	silent let g:is_git_dir = len(system('git rev-parse --git-dir 2>/dev/null')) > 0
	let l:dir_path = expand("%:p:h")
	"echo g:is_git_dir
	if g:is_git_dir
		silent let l:dir_path = system("git rev-parse --show-toplevel")
	endif
	lcd `=l:dir_path`
endfunction

function! LeftStatusline() abort
	let l:readonly = &readonly ? '[RO]' : ''
	let l:preview  = &previewwindow ? '[PREVIEW]' : ''
	let l:modified = &modified ? '[*]' : ''
	let l:git_branch = ShowGitBranch()

	let l:line_string = GetMode() . ' '
	let l:line_string = l:line_string . PrettyPrintCurrentDirectory() . ' '
	let l:line_string = l:line_string . ShowGitBranch() . ' '
	let l:line_string = l:line_string . PrettyPrintCurrentFilePath() . ' '
	"let l:line_string = l:line_string . ShowGitDiffSummary() . ' '
	let l:line_string = l:line_string . l:readonly . l:preview .  l:modified .  ' '
	return substitute(l:line_string, '  ', ' ', 'g')
endfunction

function! RightStatusLine() abort
	let l:filetype = len(&filetype) ? &filetype . ' ' : ''
	let l:fileformat = len(&fileformat) ? &fileformat . ' ' : ''
	let l:fileencoding = len(&fileencoding) ? '[' . &fileencoding . '] ' : ''

	let l:line_string = l:filetype
	let l:line_string = l:line_string . l:fileformat . ' '
	let l:line_string = l:line_string . l:fileencoding
	let l:line_string = l:line_string . GetFileSize() . ' '

	return substitute(l:line_string, '  ', ' ', 'g')
endfunction

function! PrettyPrintCurrentDirectory() abort
	let l:dir_path = pathshorten(fnamemodify(getcwd(), ":~"))
	return l:dir_path
endfunction

function! ShowGitBranch() abort
	if g:is_git_dir
		silent let l:git_branch = system('git rev-parse --abbrev-ref HEAD')[:-2]
		return l:git_branch
	endif
	return ""
endfunction

function! PrettyPrintCurrentFilePath() abort
	let l:dir_path = pathshorten(expand("%:~:."))
	return len(l:dir_path) ? l:dir_path : '[NO NAME]'
endfunction

function! ShowGitDiffSummary() abort
	if len(expand("%f")) == 0
		return ""
	endif

	if g:is_git_dir > 0
		silent let l:git_hunks = system('git  diff --numstat ' .  expand("%f"))[:-2]
		let l:git_hunks = substitute(l:git_hunks, expand("%f"), '', '')
		return '{ ' . l:git_hunks . ' }'
	endif
	return ""
endfunction

function! GetFileSize() abort
	let l:bytes = getfsize(expand("%"))
	let l:divisor = 1.0
	let l:suffix = " Bytes"

	if l:bytes <= 0
		return ''
	elseif l:bytes >= 1000000
		let l:divisor = 10000000.0
		let l:suffix = " MB"
	elseif l:bytes >= 1000
		let l:divisor = 1000.0
		let l:suffix = "KB"
	endif

	let l:bytes = l:bytes / l:divisor

	return printf("%5.1f %s", l:bytes, l:suffix)
endfunction

function! GetMode() abort
	let l:mode = mode()[0]
	if l:mode == 'v'
		" Highlight pink
		" TODO
	elseif l:mode == 'i'
		" Highlight pink
		" TODO
	elseif l:mode == 'c'
		" Highlight pink
		" TODO
	elseif l:mode == 'R'
		" Highlight pink
		" TODO
	elseif l:mode == 'N'
		" Highlight pink
		" TODO
	endif
	return '[' . g:currentmode[mode()] . ']'
endfunction

let g:currentmode = {
	\ 'n'   		: 'N',
	\ 'no'  		: 'N-Operator Pending',
	\ 'niI' 		: 'N',
	\ 'niR' 		: 'N',
	\ 'niV' 		: 'N',
	\ 'v'   		: 'VISUAL',
	\ 'V'   		: 'V-Line',
	\ ''  		: 'V-Block',
	\ 's'   		: 'S',
	\ 'S'   		: 'S-Line',
	\ 'i'   		: 'INSERT',
	\ 'ic'  		: 'I',
	\ 'ix'  		: 'I',
	\ 'R'   		: 'REPLACE',
	\ 'Rc'  		: 'R',
	\ 'Rv'  		: 'V-Replace',
	\ 'Rx'  		: 'R',
	\ 'c'   		: 'COMMAND',
	\ 'cv'  		: 'Vim-Ex',
	\ 'ce'  		: 'Ex',
	\ 'r'   		: 'Prompt',
	\ 'rm'  		: 'More',
	\ 'r?'  		: 'Confirm',
	\ '!'   		: 'Shell',
	\ 't'   		: 'Terminal',
\}

