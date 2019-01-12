" -------------------------------------------------------------"
" Basic options                                             BO
" -------------------------------------------------------------"
set nocompatible
set number
set laststatus=2
set noshowmode
set wildmenu
set encoding=utf8
set background=dark
set nowrap
"set cursorline
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
set foldlevel=20
set foldlevelstart=20
set list
set listchars=tab:\|\ 
set linebreak
set colorcolumn=81
set t_Co=256

" Tabbing and indentation
set expandtab
set tabstop=4
set shiftwidth=4
set softtabstop=4
set backspace=indent,eol,start

" Completion
set completeopt=menuone,preview,noinsert,noselect

autocmd BufEnter * call s:CDToGitRoot()
autocmd BufWritePost * call s:GetGitDiffNumstat()

" Make system
let g:projectName=fnamemodify(getcwd(), ":t")
set makeprg=meson\ build

" -------------------------------------------------------------"
" vim-plug                                                  VP
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
    Plug 'Shougo/deoplete-clangx', {'for': 'cpp'}
    Plug 'Shougo/neoinclude.vim', {'for': 'cpp'}
    Plug 'carlitux/deoplete-ternjs', {'for': 'js'}
endif
Plug 'raimondi/delimitMate'
Plug 'scrooloose/nerdcommenter'
Plug 'scrooloose/nerdtree', {'on': 'NERDTreeToggle'}
Plug 'xuyuanp/nerdtree-git-plugin', {'on': 'NERDTreeToggle'}
Plug 'nathanblair/vim-dracula-theme', {'as': 'vim-dracula-theme'}
Plug 'mhinz/vim-signify'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'
Plug 'majutsushi/tagbar', { 'for': 'cpp' }
Plug 'derekwyatt/vim-fswitch', { 'for': 'cpp' }
"Plug 'vim-airline/vim-airline'
Plug 'mattn/emmet-vim', {'for': 'html'}
Plug 'kien/ctrlp.vim'
call plug#end()


" -------------------------------------------------------------"
" vim-plug settings                                         PS
" -------------------------------------------------------------"
" Signify
let g:signify_vcs_list=['git']
let g:signify_disable_by_default = 1

" Deoplete
let g:deoplete#enable_at_startup=1

" DelimitMate
let delimitMate_expand_cr=1
let delimitMate_expand_space=1
let delimitMate_jump_expansion=1

" NERDTree
let g:NERDTreeMinimalUI = 1
let g:NERDTreeStatusline = -1
let g:NERDTreeChDirMode = 2
let g:NERDTreeStatusline=" NERDTree"

" Color scheme
set termguicolors
color dracula

" -------------------------------------------------------------"
" Language settings                                         LS
" -------------------------------------------------------------"
" Python
let g:deoplete#sources#jedi#show_docstring=1


" -------------------------------------------------------------"
" keymaps                                                   KM
" -------------------------------------------------------------"
" Stupid fucking q key...
nnoremap <silent> q <Nop>

" Edit vim config file
nnoremap <silent> <Leader>vim :e! ~/.vimrc<CR>

" Source file
nnoremap <silent> <Leader>r :source ~/.vimrc<CR>

" Folding and leader remaps
nnoremap ; za
nmap <Space> \

" Write buffer to filesystem
nnoremap <silent> <Leader>w :w<CR>
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

" Make system
nnoremap <C-b> :make<CR>
nnoremap <F5> :!ninja -C build<CR>
inoremap <expr><S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"


" -------------------------------------------------------------"
" vim-plug keymaps                                          PK
" -------------------------------------------------------------"
" Vim-Signify
nnoremap <silent> <Leader>g :SignifyToggle<CR>
"
" Commenting
imap <silent> <C-c> <plug>NERDCommenterInsert

" NERDTree
nnoremap <Leader>b :NERDTreeToggle<CR>

" Tagbar
nnoremap <silent> <Leader>t :TagbarToggle<CR>

" FSwitch
nnoremap <silent> <F4> :FSHere<CR>

" -------------------------------------------------------------"
" Statusline Customization                                  SL
" -------------------------------------------------------------"
set statusline=
set statusline+=%#type#
set statusline+=%(\ %{PrettyPrintCurrentDirectory()}%)
set statusline+=\ \|
set statusline+=%(\ %{PrettyPrintCurrentFilePath()}%)
" TODO
" Show git status
"set statusline+=%#keyword#
"set statusline+=%(\ [%{toupper(&filetype)}]%)
set statusline+=\%#rubyfunction#
set statusline+=%(\ \ %{g:git_branch}%)
set statusline+=%(\ %)
set statusline+=%#modemsg#
set statusline+=\ %(%m%r%w\ %)
set statusline+=%{ChangeStatuslineColor()}
set statusline+=%#statusline#
set statusline+=%=
set statusline+=\ %#rubyinstancevariable#
set statusline+=%(\ %{toupper(&fileencoding)}%)
set statusline+=\ <%{&fileformat}>
set statusline+=\%#string#
set statusline+=\ %{PrintIndentStyle()}
set statusline+=\%#rubyfunction#
set statusline+=\ col:%v
set statusline+=\%#normal#
set statusline+=%(\%{GetFileSize()}%)
set statusline+=\ %*

" -------------------------------------------------------------"
" Helper functions                                          HF
" -------------------------------------------------------------"
function! s:CDToGitRoot() abort
    silent let g:is_git_dir = len(system('git rev-parse --git-dir 2>/dev/null')) > 0
    let g:git_branch = ''
    let l:dir_path = expand("%:p:h")
    if g:is_git_dir
        silent let l:dir_path = system("git rev-parse --show-toplevel")
        silent let g:git_branch = system("git rev-parse --abbrev-ref HEAD")[:-2]
    endif
    cd `=l:dir_path`
    let $PWD = getcwd()
    lcd `=l:dir_path`
endfunction

function! ChangeStatuslineColor() abort
    let l:mode=mode()
    if (l:mode =~# '\v(n|no)')
        execute 'hi! StatusLine guibg=#282a36'
    elseif (l:mode =~# '\v(c|cv|ce)')
        execute 'hi! StatusLine guibg=#f1fa8c'
    elseif (l:mode =~# '\v(i|ic|ix)')
        execute 'hi! StatusLine guibg=#50fa7b'
    elseif (l:mode =~# '\v(R|Rc|Rx)')
        execute 'hi! StatusLine guibg=#8be9fd'
    elseif (l:mode ==# 't')
        execute 'hi! StatusLine guibg=#ff5555'
    elseif (l:mode ==? 'v' || l:mode ==? '')
        execute 'hi! StatusLine guibg=#ff79c6'
    else
        execute 'hi! StatusLine guibg=#282a36'
    endif
    return ''
endfunction

function! s:GetGitDiffNumstat() abort
    " git diff --numstat expand(%) | awk '{print '[+]'$1' [-]'$2}'
    "silent let g:git_numstat = system("git diff --numstat")[:-2]
    "echom l:git_numstat

    return ''
endfunction

function! PrettyPrintCurrentDirectory() abort
    if &filetype=="help" | return '' | endif

    let l:dir_path = pathshorten(fnamemodify(getcwd(), ":~"))
    return l:dir_path
endfunction

function! PrettyPrintCurrentFilePath() abort
    if &filetype=="help" | return '' | endif

    let l:dir_path = pathshorten(expand("%:~:."))
    return len(l:dir_path) ? l:dir_path : '[NO NAME]'
endfunction

function! PrintIndentStyle() abort
    return &expandtab ? "[ ]" : "[\\t]"
endfunction

" This should happen on bufwritepost as well
function! GetFileSize() abort
    let l:bytes = getfsize(expand("%"))
    let l:divisor = 1.0
    let l:suffix = "B "

    if l:bytes <= 0
        return ''
    elseif l:bytes >= 1000000
        let l:divisor = 10000000.0
        let l:suffix = "MB"
    elseif l:bytes >= 1000
        let l:divisor = 1000.0
        let l:suffix = "KB"
    endif

    let l:bytes = l:bytes / l:divisor

    return printf("%6.1f %s", l:bytes, l:suffix)
endfunction

