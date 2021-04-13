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
set relativenumber
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
set linebreak
set breakindentopt=shift:2
set nolist
"set iskeyword-=_
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

" Vim sh syntax fixing for arbitrary shells
let g:is_posix=0

" Wrap if in preview window
autocmd BufWinEnter * if &previewwindow | setlocal wrap | endif
autocmd BufWinEnter * if nvim_win_get_config(0)["relative"] != "" | setlocal nofoldenable | endif

autocmd BufWinEnter * :call UpdateWorkingPathRoot()

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
nnoremap <A-j> <C-w>+
nnoremap <A-k> <C-w>-
nnoremap <A-h> <C-w>>
nnoremap <A-l> <C-w><

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
"nnoremap <silent> <A-j> :m+1<CR>
"nnoremap <silent> <A-k> :m-2<CR>

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
"set statusline=%#WildMenu#%(\ %{PrettyPrintCurrentDirectory()}\ %)
"set statusline+=%#modemsg#%(\ %{ShowVCSBranch()}\ %)
"set statusline+=%#TermCursor#%(\ %{PrettyPrintCurrentFilePath()}\ %)
"set statusline+=%#modemsg#%(\ %m%r%w\ %)
"set statusline+=%(%{ChangeStatuslineColor()}%#StatusLine#%)
"set statusline+=%=
"set statusline+=%(%{ShowBufferList()}%)
"set statusline+=%=
"set statusline+=%#keyword#%(\ [%{&filetype}]%)
"set statusline+=%#helpCommand#%-10(\ %{&fileencoding}<%{&fileformat}>%)
"set statusline+=%#string#
"set statusline+=%(%{&expandtab ? '[ ]' : '[\\t]'}%)
"set statusline+=%-5(%#Title#\ C:%v%)
"set statusline+=%-10(%#normal#%{GetFileSize()}%)

" -------------------------------------------------------------"
" Helper functions                                          HF
" -------------------------------------------------------------"
function! UpdateWorkingPathRoot() abort
  let b:git_root_path = substitute(
    \system("basename $(git rev-parse --show-toplevel 2> /dev/null) 2> /dev/null || echo ''"),
    \"\n",
    \"",
    \"")
endfunction

function! ShowVCSBranch() abort
  if b:git_root_path != "" && &filetype != "help"
    let l:branch_name = substitute(
      \system("basename $(git branch --show-current 2> /dev/null) 2> /dev/null || echo ''"),
      \"\n",
      \"",
      \"")
    return " " . l:branch_name
  endif
  return ""
endfunction

" FIXME
function! ChangeStatuslineColor() abort
  let l:mode=mode()
  if (l:mode ==# "\v(i|ic|ix)")
    execute "hi! StatusLine guibg=#50fa7b ctermbg=Green"
  elseif (l:mode ==# "\v(c|cv|ce)")
    execute "hi! StatusLine guibg=#f1fa8c ctermbg=Black"
  elseif (l:mode ==# "\v(R|Rc|Rx)")
    execute "hi! StatusLine guibg=#8be9fd ctermbg=Cyan"
  elseif (l:mode ==# "t")
    execute "hi! StatusLine guibg=#ff5555 ctermbg=Magenta"
  elseif (l:mode ==? "v" || l:mode ==? "")
    execute "hi! StatusLine guibg=#ff79c6 ctermbg=LightRed"
  else
    execute "hi! StatusLine guibg=#282a36 ctermbg=White"
  endif
  return ""
endfunction

function! PrettyPrintCurrentDirectory() abort
  if &filetype=="help"
    return "" 
  elseif b:git_root_path != ""  
    return b:git_root_path 
  else
    return pathshorten(fnamemodify(getcwd(), ":~"))
  endif
endfunction

function! PrettyPrintCurrentFilePath() abort
  if &filetype == "help"
    return "" 
  " FIXME show file path relative to 'UpdateWorkingPathRoot'
  "elseif b:git_root_path != ""  
    "return b:git_root_path 
  else
    let l:dir_path = pathshorten(expand("%:~:."))
    return len(l:dir_path) ? l:dir_path : "[NO NAME]"
  endif

endfunction

function! ShowBufferList() abort
  let l:buffer_array = ""

  let l:raw_buffer_array = split(execute("ls"), "\n")
  if len(l:raw_buffer_array) == 1 || &filetype == "help" | return "" | endif

  for each_raw_buffer in l:raw_buffer_array
    let l:each_raw_buffer_split = split(each_raw_buffer)
    
    let l:filename_index = 1
    let l:active = 0
    let l:each_raw_buffer_length = len(l:each_raw_buffer_split)
    if l:each_raw_buffer_length == 5
      let l:filename_index = 2
      let l:active = l:each_raw_buffer_split[1] =~ "a"
    elseif l:each_raw_buffer_length == 6
      let l:filename_index = 3
      let l:active = l:each_raw_buffer_split[1] =~ "a"
    endif


    let l:formatted_file_name = substitute(l:each_raw_buffer_split[l:filename_index], "\"", "", "g")
    if l:active
      let l:formatted_file_name = "< " . l:formatted_file_name . " >"
    endif

    let l:buffer_array = l:buffer_array . " " . l:formatted_file_name
  endfor

  return l:buffer_array
endfunction

function! GetFileSize() abort
  let l:bytes = getfsize(expand("%"))
  let l:divisor = 1.0
  let l:suffix = 'B '

  if l:bytes <= 0
    return ''
  elseif l:bytes >= 1000000
    let l:divisor = 10000000.0
    let l:suffix = 'MB'
  elseif l:bytes >= 1000
    let l:divisor = 1000.0
    let l:suffix = 'KB'
  endif

  return printf('%6.1f %s', l:bytes / l:divisor, l:suffix)
endfunction

