" -------------------------------------------------------------"
" Basic options                                             BO
" -------------------------------------------------------------"
set nocompatible
set number
set laststatus=2
set noruler
set noshowmode
set wildmenu
set signcolumn=yes
set encoding=utf8
set background=dark
set noswapfile
set nobackup
set shortmess=WIcFT
set updatetime=400
set nohlsearch
set wildcharm=<C-z>
set mouse=nv

" Viewing and getting around
set nostartofline
set listchars=""
set cmdheight=1
set previewheight=6
set sidescroll=1
set sidescrolloff=5
set scrolloff=5
set splitbelow
set splitright
set ttimeoutlen=10
set colorcolumn=79
set nowrap
set nolist
set t_Co=256

" Folding
set foldmethod=indent
"set foldlevelstart=1
"set foldlevel=5
"set foldnestmax=2
"set foldcolumn=2
"set foldclose="all"

" Tabbing and indentation
set expandtab
set tabstop=2
set shiftwidth=2
set softtabstop=2
set backspace=indent,eol,start

" Folding and filetype specific settings
"let javaScript_fold=1

" Project Management
if (system('uname -o') == 'GNU/Linux')
  autocmd BufEnter * call s:CDToGitRoot()
endif
"autocmd BufWritePost * call s:GetGitDiffNumstat()
let g:projectName=fnamemodify(getcwd(), ":t")

" Vim sh syntax fixing for arbitrary shells
let g:is_posix=0

" Make system
set makeprg=ninja\ -C\ build

" Wrap if in preview window
autocmd BufWinEnter * if &previewwindow | setlocal wrap | endif
autocmd BufWinEnter * if nvim_win_get_config(0)['relative'] != '' | setlocal nofoldenable | endif

" -------------------------------------------------------------"
" vim-plug                                                  VP
" -------------------------------------------------------------"
source ~/.vimplug

" -------------------------------------------------------------"
" keymaps                                                   KM
" -------------------------------------------------------------"
" Stupid fucking q key...
nnoremap <silent> q <Nop>

" Edit vim config file
nnoremap <silent> <Leader>vim :e! ~/.vimrc<CR>

" Move using visual lines
"nnoremap <silent> j gj
"nnoremap <silent> k gk

" Source file
nnoremap <silent> <Leader>r :source ~/.vimrc<CR>

" Folding and leader remaps
nnoremap ; za
map <Space> \
"inoremap <C-Space> <ESC>

" Sizing vim windows
nnoremap = <C-w>+
nnoremap + <C-w>_
nnoremap - <C-w>-
nnoremap <A-.> <C-w>>
nnoremap <A-,> <C-w><

" Write buffer to filesystem
nnoremap <silent> <Leader>w :w<CR>
nnoremap <silent> <Leader>Q :qa<CR>

" Toggle wrap
nnoremap <silent> <Leader>z :set wrap!<CR>

" Substitute
nnoremap <Leader>s :%s/

" Highlight
nnoremap <Leader>n :noh<CR>

" Join lines
nnoremap <silent> <C-j> :join<CR>

" Swap lines
nnoremap <silent> <A-j> :m+1<CR>
nnoremap <silent> <A-k> :m-2<CR>

" Add lines above and below
nnoremap <silent> J mGo<ESC>`G
nnoremap <silent> K mGO<ESC>`G

" Cycle between buffers and close them
nnoremap <silent> <TAB> :bn!<CR>
nnoremap <silent> <S-TAB> :bp!<CR>
nnoremap <silent> <Leader>d :bp!\|bd #<CR>
nnoremap <silent> <Leader>D :bd<CR>
nnoremap <silent> <Leader>p :pc<CR>
nnoremap <silent> <Leader>o :helpclose<CR>
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
noremap <Leader>e :e **/*

" Help shortcut
nnoremap <C-h> :h

" -------------------------------------------------------------"
" Statusline Customization                                  SL
" -------------------------------------------------------------"
set statusline=
set statusline+=%#type#
set statusline+=%(\ %{PrettyPrintCurrentDirectory()}%)
set statusline+=\%#normal#
set statusline+=%(\ \|\ %{PrettyPrintCurrentFilePath()}%)
" TODO
" Show git status
"set statusline+=\%#rubyfunction#
"set statusline+=%(\ \ %{b:git_branch}%)
set statusline+=%#modemsg#
set statusline+=\ %(%m%r%w\ %)
set statusline+=%{ChangeStatuslineColor()}
set statusline+=%#statusline#
set statusline+=%=
set statusline+=%#keyword#
set statusline+=%(\ [%{toupper(&filetype)}]\ %)
set statusline+=\%#helpCommand#
"set statusline+=%(\ %{toupper(&fileencoding)}%)
set statusline+=\ %(<%{&fileformat}>\ %)
"set statusline+=\%#string#
"set statusline+=\ %{PrintIndentStyle()}
set statusline+=\%#rubyfunction#
"set statusline+=\ col:%v
set statusline+=\%#normal#
set statusline+=%(\%{GetFileSize()}%)
set statusline+=\ %*

" -------------------------------------------------------------"
" Helper functions                                          HF
" -------------------------------------------------------------"
function! ToggleSourceHeaderDocFile() abort
  execute 'edit' CocRequest('clangd', 'textDocument/switchSourceHeader', {'uri': 'file://'.expand("%:p")})
endfunction

function! s:CDToGitRoot() abort
    silent let b:is_git_dir = len(system('git rev-parse --git-dir 2>/dev/null')) > 0
    let b:git_branch = ''
    let l:dir_path = expand("%:p:h")
    if b:is_git_dir
        silent let l:dir_path = system("git rev-parse --show-toplevel")
        silent let b:git_branch = system("git rev-parse --abbrev-ref HEAD")[:-2]
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

function! ShowDocumentation() abort
  if &filetype == 'vim'
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
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
