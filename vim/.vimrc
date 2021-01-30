"
"             __
"     __  __ /\_\    ___ ___   _ __   ___
"    /\ \/\ \\/\ \ /' __` __`\/\`'__\/'___\
"  __\ \ \_/ |\ \ \/\ \/\ \/\ \ \ \//\ \__/
" /\_\\ \___/  \ \_\ \_\ \_\ \_\ \_\\ \____\
" \/_/ \/__/    \/_/\/_/\/_/\/_/\/_/ \/____/
"
"

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
set formatoptions-=cro " Disable continuation of comment at linebreaks
set filetype=dosini

" Tell vim to use xterm keys
" This is needed to be able to use <C-arrowkeys>
execute "set <xUp>=\e[1;*A"
execute "set <xDown>=\e[1;*B"
execute "set <xRight>=\e[1;*C"
execute "set <xLeft>=\e[1;*D"

" And the obligatory disabling of space
"nnoremap <SPACE> <Nop>
" Space is leader
let mapleader=" "

" Colors
set background=dark " A must for gruvbox + compton transparancy


" Highlight trailing whitespaces
highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/

" Yellow background with black text makes for
" great visibility with search results
hi Search ctermbg=Yellow
hi Search ctermfg=Black

" Popup menu (for autocomplete etc)
hi Pmenu guibg=#b8bb26 ctermbg=100
hi PmenuSel guibg=#3a3a3a ctermbg=237

" Vimdiff colors
"hi DiffAdd ctermbg=
hi DiffChange ctermbg=95
"hi DiffDelete ctermbg=
"hi DiffText ctermbg=

" If we start in diff mode, turn off syntax highlighting
if &diff
    syntax off
endif

" Always keep cursor at least 5 rows from top/bottom, when searching/zt etc
set scrolloff=5

" Switch back to normal mode after a few seconds, here 25 sec
au CursorHoldI * stopinsert
au InsertEnter * let updaterestore=&updatetime | set updatetime=25000
au InsertLeave * let &updatetime=updaterestore


" Make right/lower window be the active one at a split
set splitright
set splitbelow


" CTags looks recursivly on directory up all the way to root
set tags=tags;/

" Diable Ex mode
nmap Q <Nop>

" ____ ____ ____ ____ ____ ____ ____ ____ ____ ____ ____
"||K |||E |||Y |||B |||I |||N |||D |||I |||N |||G |||S ||
"||__|||__|||__|||__|||__|||__|||__|||__|||__|||__|||__||
"|/__\|/__\|/__\|/__\|/__\|/__\|/__\|/__\|/__\|/__\|/__\|
"
" Scrolling faster
nnoremap <C-Down> 3<C-e>
nnoremap <C-Up> 3<C-y>

" Buffer navigation
set hidden
nmap <Left> :bprevious<cr>
nmap <Right> :bnext<cr>
nmap <leader>q :bdelete<cr>

" List open buffers
nmap <leader>l :ls<cr>

" CtrlP
nmap <leader>c :CtrlP<cr>

" Scroll
nmap <Up> <C-y>
nmap <Down> <C-e>

" YCMCompleter
nmap <leader>f :YcmCompleter FixIt<cr>

" Cscope extended regex search
noremap <leader>e :cs find e

" Esc to remove search findings
nnoremap <esc> :noh<return><esc>
nnoremap <esc>^[ <esc>^[

" Search for text selected in visual mode
vnoremap // y/<C-R>"<CR>

" Yank/paste to/from +-register/system clipboard
vnoremap <leader>y "+y
nnoremap <leader>p "+p

" Search and replace
xnoremap <leader>sr y:<C-U>let replacement = input('Enter replacement string: ') <bar> %s/<C-R>"/\=replacement/g<CR>
xnoremap <leader>sc y:<C-U>let replacement = input('Enter replacement string: ') <bar> %s/<C-R>"/\=replacement/gc<CR>

" Exit insert mode with jj
inoremap jj <esc>

" Remove trailing white space in file
noremap <leader>w :%s/\s\+$//g<CR>

" Toggle between header and source
"map <silent> <F4> :call ToggleBetweenHeaderAndSourceFile()<CR>

" Change directory to the current buffer when opening files.
"set autochdir



" netrw
"let g:netrw_banner = 0
"let g:netrw_liststyle = 3
"let g:netrw_browse_split = 4
"let g:netrw_altv = 1
"let g:netrw_winsize = 25
"augroup ProjectDrawer
"  autocmd!
"  autocmd VimEnter * :Vexplore
"augroup END



"map <silent> <C-W> :call ToggleVExplorer()<CR>
"Toggle relative numbers
map <leader>l :set rnu!<CR>
"Toggle nerdtree
map <f12> :NERDTreeToggle<CR>
" Toggle lessMode
nnoremap <F5> :call LessMode()<CR>
let g:lessmode = 0



" Ugly little snippet done the Luke Smith-way, prints std::cout
autocmd FileType cpp inoremap ;co std::cout<Space><<<Space>"f"<Space><<<Space>std::endl;<Esc>Ffcw
" Same thing but for spdlog, they way it is set up in Timber/Cargo-Server
autocmd FileType cpp inoremap ;spd spdlog::get("log")->info("q");<Esc>Fqcw
" Same thing for printf
autocmd FileType c inoremap ;pf printf("q");<Esc>Fqcw
autocmd FileType cpp,c inoremap ;for for (int i = 0; i < q; i++)<CR>{<CR><CR>}<CR><Esc>kkkk0fqcw

" For escaped quotes
autocmd FileType cpp inoremap ++2 \"

" std::string
autocmd FileType cpp inoremap ;ss std::string


" ____ ____ ____ ____ ____ ____ ____ ____
"||N |||E |||R |||D |||T |||R |||E |||E ||
"||__|||__|||__|||__|||__|||__|||__|||__||
"|/__\|/__\|/__\|/__\|/__\|/__\|/__\|/__\|
"
" Start up nerdtree automatically if no files were specified
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif

"Close vim if nerdtree is the only window left open
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif


" ____ ____ ____ ____ ____ ____ ____ ____ ____
"||P |||O |||W |||E |||R |||L |||I |||N |||E ||
"||__|||__|||__|||__|||__|||__|||__|||__|||__||
"|/__\|/__\|/__\|/__\|/__\|/__\|/__\|/__\|/__\|
"
"python from powerline.vim import setup as powerline_setup
"python powerline_setup()
"python del powerline_setup
set laststatus=2            " Always display powerline in all windows
set showtabline=2           " Always show tabline, even if there's just one tab
set noshowmode              " Hide the default mode text (e.g. -- INSERT -- below the statusline)
set t_Co=256               " Use 256 colors (Use this setting only if your terminal supports 256 colors)

" ____ ____ ____ ____ ____ ____ ____
"||P |||L |||U |||G |||I |||N |||S ||
"||__|||__|||__|||__|||__|||__|||__||
"|/__\|/__\|/__\|/__\|/__\|/__\|/__\|
"

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'VundleVim/Vundle.vim' "Required

" <======== PLUGINS ========>

Plugin 'scrooloose/nerdtree'
Plugin 'ctrlpvim/ctrlp.vim'
"Plugin 'Valloric/YouCompleteMe'
"Plugin 'rdnetto/YCM-Generator'
Plugin 'neoclide/coc.nvim', {'branch': 'release'}
Plugin 'tpope/vim-fugitive.git'
Plugin 'junegunn/fzf.vim', { 'do': { -> fzf#install() } }
Plugin 'morhetz/gruvbox' 
Plugin 'sheerun/vim-polyglot'
"Plugin 'jeetsukumaran/vim-buffergator'
"Plugin 'terryma/vim-multiple-cursors'
"Plugin 'mattn/vim-starwars'

" <======== /PLUGINS =======>

" To use C-family semantic complition with YCM:
" Add -DCMAKE_EXPORT_COMPILE_COMMANDS=ON to cmake when generating the
" makefiles and (if needed) move the resulting compile_commands.json to same directory as
" the source files, or any directory recursively above it

call vundle#end()
filetype plugin indent on "Required by vundle
filetype on "Okey again after last Vundle command

" Cursorline
set cursorline
noremap <leader>cl :set cursorline!<CR>
hi CursorLine term=none cterm=none ctermbg=237
" Only show CursorLine in current window
augroup CursorLine
  au!
  au VimEnter,WinEnter,BufWinEnter * setlocal cursorline
  au WinLeave * setlocal nocursorline
augroup END

" Use ripgrep with fzf
set rtp+=~/.fzf
nmap <leader>r :Rg<cr>

let g:gruvbox_contrast_dark = 'hard'
let g:gruvbox_transparent_bg = 1
let g:gruvbox_termcolors = 16

" Gruvbox colors
colo gruvbox
"
" Toggle Vexplore with Ctrl-E
"function! ToggleVExplorer()
"  if exists("t:expl_buf_num")
"      let expl_win_num = bufwinnr(t:expl_buf_num)
"      if expl_win_num != -1
"          let cur_win_nr = winnr()
"          exec expl_win_num . 'wincmd w'
"          close
"          exec cur_win_nr . 'wincmd w'
"          unlet t:expl_buf_num
"      else
"          unlet t:expl_buf_num
"      endif
"  else
"      exec '1wincmd w'
"      Vexplore
"      let t:expl_buf_num = bufnr("%")
"  endif
"endfunction
"
"" Toggle between header and source file
"function! ToggleBetweenHeaderAndSourceFile()
"  let bufname = bufname("%")
"  let ext = fnamemodify(bufname, ":e")
"  if ext == "h"
"    let ext = "cpp"
"  elseif ext == "cpp"
"    let ext = "h"
"  else
"    return
"  endif
"  let bufname_new = fnamemodify(bufname, ":r") . "." . ext
"  let bufname_alt = bufname("#")
"  if bufname_new == bufname_alt
"    execute ":e#"
"  else
"    execute ":e " . bufname_new
"  endif
"endfunction

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

" Jump to the next or previous line that has the same level or a lower
" level of indentation than the current line.
"
" exclusive (bool): true: Motion is exclusive
" false: Motion is inclusive
" fwd (bool): true: Go to next line
" false: Go to previous line
" lowerlevel (bool): true: Go to line with lower indentation level
" false: Go to line with the same indentation level
" skipblanks (bool): true: Skip blank lines
" false: Don't skip blank lines
function! NextIndent(exclusive, fwd, lowerlevel, skipblanks)
  let line = line('.')
  let column = col('.')
  let lastline = line('$')
  let indent = indent(line)
  let stepvalue = a:fwd ? 1 : -1
  while (line > 0 && line <= lastline)
    let line = line + stepvalue
    if ( ! a:lowerlevel && indent(line) == indent ||
          \ a:lowerlevel && indent(line) < indent)
      if (! a:skipblanks || strlen(getline(line)) > 0)
        if (a:exclusive)
          let line = line - stepvalue
        endif
        exe line
        exe "normal " column . "|"
        return
      endif
    endif
  endwhile
endfunction

" Moving back and forth between lines of same or lower indentation.
nnoremap <silent> [l :call NextIndent(0, 0, 0, 1)<CR>
nnoremap <silent> ]l :call NextIndent(0, 1, 0, 1)<CR>
nnoremap <silent> [L :call NextIndent(0, 0, 1, 1)<CR>
nnoremap <silent> ]L :call NextIndent(0, 1, 1, 1)<CR>
vnoremap <silent> [l <Esc>:call NextIndent(0, 0, 0, 1)<CR>m'gv''
vnoremap <silent> ]l <Esc>:call NextIndent(0, 1, 0, 1)<CR>m'gv''
vnoremap <silent> [L <Esc>:call NextIndent(0, 0, 1, 1)<CR>m'gv''
vnoremap <silent> ]L <Esc>:call NextIndent(0, 1, 1, 1)<CR>m'gv''
onoremap <silent> [l :call NextIndent(0, 0, 0, 1)<CR>
onoremap <silent> ]l :call NextIndent(0, 1, 0, 1)<CR>
onoremap <silent> [L :call NextIndent(1, 0, 1, 1)<CR>
onoremap <silent> ]L :call NextIndent(1, 1, 1, 1)<CR>


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
" [{ to go to top of scope or code block
" ]} to go to bottom of scope or code block
"
" TODO:
" vim-airline with tabs (nah), or maybe rather CtrlP DONE
" nerdtree, or perhaps netrw DONE
" ctags DONE
" youcompleteme DONE
"
" Ascii art font:
" patorjk.com
" 'Larry 3D'
"
" Fix shortcuts for buffnext, buffprev, buffclose DONE
" Fix shortcut for CtrlP, YcmCompleter FixIt DONE
" Fix shortcut for C-e, C-y-scrolling DONE
"
" vim-multiple-cursors
"
"
" HOWTOS:
"
" Cscope:
" Install cscope and run it with cscope -Rb in the project root dir. -b tells
" cscope to just build the database, not enter that ugly ncurses-interface
" Download and place the cscope_maps.vim in ~/.vim/plugins/
" Ctrl-\ s for finding symbol under cursor, Ctrl-space s for finding it and
" opening it in a horizontal split, Ctrl-space Ctrl-space s for finding it and opening it
" in a vertical split
" To serach for arbitrary text, do :cs find e text\ here\ with\ spaces\
"
"
" To look for commit message when using git log, do git log --all -i
" --grep='improved slices'
" escaped
"
" Rsync a file with the same name within subdirectories and create the same
" subdirectories locally, for example download logfiles and create their
" corresponding subdirectories locally
" rsync -arv --include="*/" --include="logfile" --exclude="*" dsv-jkpg-1:/data/passages/2019-06-19/ .
"
" Same thing but bloated (only locally):
" for d in /data/passages/2019-06-14/*; do mkdir -p /root/ollebolle/$(basename ${d}); cp ${d}/logfile /root/ollebolle/$(basename ${d}); done
"
" Rsync a passage, with all it's parent folders, but only it's videofiles:
" rsync -arv --include="2019-10-16/" --include="2019-10-16/07_20_51" --include="2019-10-16/07_20_51/*.avi" --exclude="*" ljungträ:/data/passages/ .
"
" Mounting samba drive:
" sudo mount -t cifs -o username=jonas,password=stduma+T4l0n //192.168.1.90/cind /home/jonas/share/nas/
"
" Make vim session: mks ~/.vim/sessions/ollebolle.vim
"
" The next time you start vim, just source it like so:
" :source ~/.vim/sessions/ollebolle.vim
" Or start vim with the -S flag, vim -S ~/.vim
" When the time comes to exit again, you can just overwrite your old session
" with :mks!
"
" See what's in your stash: git stash show -p
"
" Remove files within a directory structure with find:
" sudo find /data/passages/ -iname 'thumbnail_*' -exec rm {} \;
"
" Run pwin and tell linker which libs to link at runtime
" LD_LIBRARY_PATH=/home/jonas/Development/pwin/timbeter.opencv3.4.1/lib/:/home/jonas/Development/pwin/pylon-5.2.0.13457-x86_64/lib64/ ./pwin -cmd ~/Development/pwin_command_files/TIM-995_dynamic_plane_offset/evalute_2019-10-31.pwin
"
"   's'   symbol: find all references to the token under cursor
"   'g'   global: find global definition(s) of the token under cursor
"   'c'   calls:  find all calls to the function name under cursor
"   't'   text:   find all instances of the text under cursor
"   'e'   egrep:  egrep search for the word under cursor
"   'f'   file:   open the filename under cursor
"   'i'   includes: find files that include the filename under cursor
"   'd'   called: find functions that function under cursor calls
"
"   Build cmake with debug flags:
"       cmake -DCMAKE_BUILD_TYPE=Debug ..
"
