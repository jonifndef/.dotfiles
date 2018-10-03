syntax on
filetype off "Required for vundle

set nocompatible
set number
set relativenumber
set shiftwidth=4
set expandtab
set tabstop=4
set softtabstop=4
set smartindent
set smarttab
set autoindent
set showmatch
set ignorecase
set hlsearch
set statusline+=%F
set backspace=2 " make backspace work like most other programs

" And the obligatory disabling of space
"nnoremap <SPACE> <Nop>
" Space is leader
let mapleader=" "

" Colors
" Yellow background with black text makes for 
" great visibility with search results
colo slate
hi Search ctermbg=Yellow 
hi Search ctermfg=Black

" Switch back to normal mode after a few seconds, here 10 sec
au CursorHoldI * stopinsert
au InsertEnter * let updaterestore=&updatetime | set updatetime=15000
au InsertLeave * let &updatetime=updaterestore

" Make right/lower window be the active one at a split
set splitright
set splitbelow

" CTags looks recursivly on directory up all the way to root
set tags=tags;/

" Scrolling faster
" nnoremap <C-e> 3<C-e>
" nnoremap <C-y> 3<C-y>

" Buffer navigation
set hidden
nmap <Left> :bprevious<cr>
nmap <Right> :bnext<cr>
nmap <leader>bq :bdelete<cr>
" List open buffers
nmap <leader>ls :ls<cr> 

" Scroll
nmap <Up> <C-y>
nmap <Down> <C-e>

" Esc to remove search findings
nnoremap <esc> :noh<return><esc>
nnoremap <esc>^[ <esc>^[

" Exit insert mode with jj
inoremap jj <esc>

" Toggle between header and source
map <silent> <F4> :call ToggleBetweenHeaderAndSourceFile()<CR>

" Change directory to the current buffer when opening files.
"set autochdir

" netrw
let g:netrw_banner = 0
let g:netrw_liststyle = 3
let g:netrw_browse_split = 4
let g:netrw_altv = 1
let g:netrw_winsize = 25
"augroup ProjectDrawer
"  autocmd!
"  autocmd VimEnter * :Vexplore
"augroup END	

"map <silent> <C-W> :call ToggleVExplorer()<CR>
"Toggle relative numbers
map <C-l> :set rnu!<CR> 
"Toggle nerdtree
map <f12> :NERDTreeToggle<CR>
" Toggle lessMode
nnoremap <F5> :call LessMode()<CR>
let g:lessmode = 0

"Ugly little snippet done the Luke Smith-way, prints std::cout
autocmd FileType cpp inoremap ;co std::cout<Space><<<Space>f<Space><<<Space>std::endl;<Esc>Ffcw
" Start up nerdtree automatically if no files were specified
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif

"Close vim if nerdtree is the only window left open
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

" <=== Powerline ===>
python from powerline.vim import setup as powerline_setup
python powerline_setup()
python del powerline_setup
set laststatus=2            " Always display powerline in all windows
set showtabline=2           " Always show tabline, even if there's just one tab
set noshowmode              " Hide the default mode text (e.g. -- INSERT -- below the statusline)
set t_Co=256               " Use 256 colors (Use this setting only if your terminal supports 256 colors) 
" <== /Powerline ===>

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'VundleVim/Vundle.vim' "Required

" <======== PLUGINS ========>

Plugin 'scrooloose/nerdtree'
Plugin 'ctrlpvim/ctrlp.vim'
Plugin 'Valloric/YouCompleteMe'
Plugin 'jeetsukumaran/vim-buffergator'

" <======== /PLUGINS =======>

" To use C-family semantic complition with YCM:
" Add -DCMAKE_EXPORT_COMPILE_COMMANDS=ON to cmake when generating the
" makefiles and (if needed) move the resulting compile_commands.json to same directory as
" the source files, or any directory recursively above it

call vundle#end()
filetype plugin indent on "Required by vundle
filetype on "Okey again after last Vundle command

" Toggle Vexplore with Ctrl-E
function! ToggleVExplorer()
  if exists("t:expl_buf_num")
      let expl_win_num = bufwinnr(t:expl_buf_num)
      if expl_win_num != -1
          let cur_win_nr = winnr()
          exec expl_win_num . 'wincmd w'
          close
          exec cur_win_nr . 'wincmd w'
          unlet t:expl_buf_num
      else
          unlet t:expl_buf_num
      endif
  else
      exec '1wincmd w'
      Vexplore
      let t:expl_buf_num = bufnr("%")
  endif
endfunction

" Toggle between header and source file
function! ToggleBetweenHeaderAndSourceFile()
  let bufname = bufname("%")
  let ext = fnamemodify(bufname, ":e")
  if ext == "h"
    let ext = "cpp"
  elseif ext == "cpp"
    let ext = "h"
  else
    return
  endif
  let bufname_new = fnamemodify(bufname, ":r") . "." . ext
  let bufname_alt = bufname("#")
  if bufname_new == bufname_alt
    execute ":e#"
  else
    execute ":e " . bufname_new
  endif
endfunction

function! LessMode()
  if g:lessmode == 0
    let g:lessmode = 1
    let onoff = 'on'
    " Scroll half a page down
    noremap <script> d <C-D>
    " Scroll one line down
    noremap <script> j <C-E>
    " Scroll half a page up
    noremap <script> u <C-U>
    " Scroll one line up
    noremap <script> k <C-Y>
  else
    let g:lessmode = 0
    let onoff = 'off'
    unmap d
    unmap j
    unmap u
    unmap k
  endif
  echohl Label | echo "Less mode" onoff | echohl None
endfunction

" Commands that are good to know (and remember)
" % to jump to next matching thingy (curly-braces, paranthesis etc)
" '' to jump to last jumped-to-cursor postition
" '. to jump to the last edited line
" * to jump to the next match of the word the cursor is currently on (n for forward, N for backwards)
" # to jump to the last match of the word the cursor is currently on (n for backwards, N for forward)
" :sp for horizontal split, :sp30 for a specific size of 30
" :vsp for vertical split
" C-w C-hjkl for switching windows (if split)
" C-a to increment value under cursor, yo
" C-x to decrement value under cursor
" Good tool for merging (like meld): vimdiff
"
"
" TODO:
" vim-airline with tabs (nah), or maybe rather CtrlP
" nerdtree, or perhaps netrw
" ctags
" youcompleteme
"
" Fix shortcuts for buffnext, buffprev, buffclose
" Fix shortcut for CtrlP, YcmCompleter FixIt
" Fix shortcut for C-e, C-y-scrolling
"
"
"
"
"
