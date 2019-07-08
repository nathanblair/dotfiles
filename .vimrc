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
set updatetime=1000
set nohlsearch
set wildcharm=<C-z>

" Viewing and getting around
set nostartofline
set cmdheight=1
set previewheight=6
set sidescroll=1
set sidescrolloff=5
set scrolloff=5
set splitbelow
set splitright
set ttimeoutlen=10
set foldmethod=indent
set foldlevel=20
set foldlevelstart=1
set foldnestmax=2
set colorcolumn=79
set nowrap
set t_Co=256

" Tabbing and indentation
set expandtab
set tabstop=2
set shiftwidth=2
set softtabstop=2
set backspace=indent,eol,start

" Folding and filetype specific settings
"let javaScript_fold=1

" Project Management
if (system('uname -o') !~ 'Msys')
  autocmd BufEnter * call s:CDToGitRoot()
endif
"autocmd BufWritePost * call s:GetGitDiffNumstat()
let g:projectName=fnamemodify(getcwd(), ":t")

" Make system
set makeprg=ninja\ -C\ builds

" Don't wrap if in preview window
autocmd BufWinEnter * if &previewwindow | setlocal wrap | endif

" Python-specific settings
"autocmd FileType python,vim setlocal foldmethod=indent

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
    Plug 'dracula/vim', {'as': 'vim-dracula-theme'}
    Plug 'scrooloose/nerdtree'
    Plug 'scrooloose/nerdcommenter'
    Plug 'neoclide/coc.nvim', {'branch': 'release'}
    Plug 'shougo/neco-vim'
    Plug 'neoclide/coc-neco'
    Plug 'tpope/vim-fugitive'
    Plug 'mhinz/vim-signify'
    Plug 'tpope/vim-surround'
    "Plug 'raimondi/delimitMate'
    Plug 'derekwyatt/vim-fswitch', { 'for': 'cpp' }
    "Plug 'sheerun/vim-polyglot'
    Plug 'pangloss/vim-javascript'
call plug#end()

" -------------------------------------------------------------"
" vim-plug settings                                         PS
" -------------------------------------------------------------"
" Signify
let g:signify_vcs_list=['git']
let g:signify_disable_by_default=1

" NERDTree
let g:NERDTreeSortHiddenFirst=1
let g:NERDTreeChDirMode=2
let g:NERDTreeHijackNetrw=1
let g:NERDTreeMinimalUI=1

" NERDCommenter
let g:NERDCreateDefaultMappings=0

" DelimitMate
let delimitMate_expand_cr=1
let delimitMate_expand_space=1
let delimitMate_jump_expansion = 1

" Color scheme
set termguicolors
augroup colorscheme_customization
  autocmd ColorScheme dracula highlight Normal ctermbg=244 guibg=#050506 
  autocmd ColorScheme dracula highlight DraculaBgDark ctermbg=244 guibg=#172030 
  autocmd ColorScheme dracula highlight DraculaBgDarker ctermbg=244 guibg=#101220
  autocmd ColorScheme dracula highlight DraculaTodo cterm=bold ctermfg=cyan gui=bold guifg=cyan guibg=none
augroup END
color dracula

" Restore some overriden colors
highlight CocUnderLine cterm=underline gui=underline
highlight link CocErrorSign Error
highlight link CocWarningSign WarningMsg
highlight link CocInfoSign Special
highlight link CocHintSign NonText
highlight link CocSelectedText Visual
highlight link CocCodeLens LineNr

highlight link CocErrorHighlight SpellBad
highlight link CocWarningHighlight SpellLocal
highlight link CocInfoHighlight SpellRare
highlight link CocHintHighlight Conceal

" -------------------------------------------------------------"
" Language Server Protocol settings                         LS
" -------------------------------------------------------------"
" Completion
"autocmd! CompleteDone * if pumvisible() == 0 | pclose | endif
set keywordprg=:call\ <SID>show_documentation()

" Documentation
"autocmd! User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
autocmd! User CocLocationsChange CocList --normal -A location
"autocmd! CursorHoldI,CursorMovedI * call CocActionAsync('showSignatureHelp')

" LSP Snippets
let g:coc_snippet_next='<TAB>'
let g:coc_snippet_prev='<S-TAB>'

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
" vim-plug keymaps                                          PK
" -------------------------------------------------------------"
" Vim-Signify
nnoremap <silent> <Leader>- :SignifyToggle<CR>

" Fugitive
" Show git status window minimized
nnoremap <silent> <Leader>gs :G<CR>8<C-w>_<C-w>p
nnoremap <silent> <Leader>gh :bd .git/index<CR>
nnoremap <silent> <Leader>gb :Gblame<CR>
nnoremap <silent> <Leader>gc :Gcommit<CR>
nnoremap <silent> <Leader>gl :Glog<CR>
nnoremap <Leader>gu :Git push<CR>
nnoremap <Leader>gd :Git pull<CR>

" NERDTree
nnoremap <silent> <C-b> :NERDTreeToggle<CR>

" NERDCommenter
nnoremap <silent> <Leader>cc :call NERDComment(0, 'toggle')<CR>
vnoremap <silent> <Leader>cc :call NERDComment(0, 'toggle')<CR>

" FSwitch
nnoremap <silent> <F4> :FSHere<CR>

" LSP Diagnostics
nnoremap <Leader>i :<C-u>CocList --normal --no-sort diagnostics<CR>
nmap <silent> <c <Plug>(coc-diagnostic-prev)
nmap <silent> >c <Plug>(coc-diagnostic-next)

" LSP Autocompletion
inoremap <silent> <expr><c-space> coc#refresh()
inoremap <expr><TAB> pumvisible() ? "\<C-y>" : "\<TAB>"
"inoremap <expr><TAB> pumvisible() ? "\<C-n>" : "\<TAB>"
"inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<S-TAB>"

" LSP Gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gt <Plug>(coc-type-defintion)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" LSP Rename
nmap <Leader>cn <Plug>(coc-rename)

" LSP CodeAction
nmap <Leader>a <Plug>(coc-codeaction)
nnoremap <Leader>; :<C-u>CocList --normal --no-sort<CR>
nnoremap <Leader>t :<C-u>CocList --normal --no-sort symbols<CR>
nnoremap <Leader>x :<C-u>CocList --normal --no-sort extensions<CR>

" LSP Documentation
nnoremap <silent> <C-k> :call ShowDocumentation()<CR>

" LSP Format
nmap <silent> <Leader>f <Plug>(coc-format)
vmap <silent> <Leader>f <Plug>(coc-format-selected)

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

