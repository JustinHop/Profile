" Justin's vimrc
" $Id$

" 
"  General Operation

" vimrc-1.9.5

set nocompatible
set backspace=2
set ttyfast

filetype plugin indent on
syntax enable

set tabpagemax=25

if has("win32")
    set cul
    set cuc
endif

set visualbell
set history=1000

" Display
set laststatus=2
set sidescrolloff=1
set linebreak
set number
set ruler

" No Switching to Alt Screen!
set t_ti= 
set t_te=
" No More MORE
set nomore

if has("mouse")
    set mouse=a
endif

set showmatch
set showmode
set showcmd
set lazyredraw
" STOLEN
"set statusline=#%n\ %<%F%m%r\ %w\ %y\ \ <%{&fileencoding},%{&fileformat}>%=%l,%c%V\ of\ %L\ \ \ \ \ \ \ %P
set statusline=#%n\ %<%F%m%r\ %w\ %y\ \ <%{&fileencoding},%{&fileformat}>%=<%{&tabstop}:%{&softtabstop}:%{&shiftwidth}:%{&expandtab}>%<\ \ \ %l,%c%V\ of\ %L\ \ \ %P
"set statusline=#%n\ %<%F%m%r\ %w\ %y\ \<%{&fileencoding},%{&fileformat}>%=%l,%c%V\ of\ %L\ \ \ \%{VimBuddy()}\ \ \%P

if version >= 700
    "  Virtual Editing
    set virtualedit=block,onemore
endif

"  Indenting Formating
set autoindent
set copyindent
set preserveindent
set smartindent
set textwidth=80
set formatoptions=roq
set nolist
set showbreak=-->\ 
set wrap
set linebreak

set smarttab
set softtabstop=4
set shiftwidth=4
set tabstop=4
set expandtab

set complete=.,k,w,b,t,i

" Folding
if has("folding")
    set foldenable
    set foldmethod=indent
    set foldminlines=3
endif

"Searching
set ignorecase
set incsearch
set smartcase
set nohlsearch
"hit C-n to disable this or :noh
"nmap <silent> <C-N> :silent noh<CR>
set isfname-==

" Insertion
set showfulltag
set wildmenu
set wildmode=list:longest,full

set shortmess=a

" Booyah
if &t_Co || has("gui_running") && ( expand($TERM) != "screen.linux")
    syntax on
    set t_Co=256
endif

if ( expand($TERM) ==# "linux" )
	set t_Co=8
	colorscheme default
endif

"
"  Same buisness for the ttymouse thing, this prolly is not backwards
"     compatible. Need to find what version this started being supported.
"
if $VIM_MOUSE
   ttymouse=$VIM_MOUSE
else
    set ttymouse=xterm2
endif  

function! MyPerlSettings()
    if !did_filetype()
        set filetype=perl
    endif

    setlocal nosmartindent
    setlocal noautoindent
    setlocal indentexpr=
    setlocal complete+=k 
    setlocal cindent 
    setlocal cinkeys=0{,0},0(,0),:,!^F,o,O,e
    setlocal formatoptions-=t formatoptions+=croq

    compiler perl
    "colorscheme wuye
endfunction


"
"  We are using VIM
"
filetype on
filetype indent on

if has("autocmd")
    filetype plugin indent on
    "jumpback
    au BufReadPost *
        \ if line("'\"") > 0 && line ("'\"") <= line("$") |
        \   exe "normal g'\"" |
        \ endif 

    " Backup EVERYTHING MODE!!!!
    "let BACKUPDIR=expand("$HOME/backup/")
    "if expand($SUDO_USER)
    	"let BACKUPDIR=expand("/home/$SUDO_USER/backup/")
    "endif
    if expand($BACKUP) !=# "-"
        if getfsize(expand("%:p")) <= 8024000
            set nobackup
            if ! expand(&readonly)
                au BufReadPost *
                            \ exe 'silent write! ' 
                            \   substitute( expand( 
                            \       substitute( expand("$HOME/backup/") .
                            \           substitute( expand("%:p"), '/','_','g') . 
                            \           strftime("%Y%m%d.%H%M%S"), 
                            \       '\s','_', 'g') 
                            \   ), '_','','')  
            endif
        endif
    else
        if has("unix")
            set backup
            set backupdir=~/backup
        endif
    endif

    " purdy colors
    if expand($TERM) == "linux"
    	colorscheme elflord
    elseif filereadable( expand("$HOME/.vim/colors/typo.vim") )
    	colorscheme typofree
    elseif filereadable( expand("$HOME/.vim/colors/lucius.vim") )
    	colorscheme lucius
    endif

    " yank to clipboard
    if executable("xclip")
    	"vnoremap y  :yank<CR>:call system("xclip -i", getreg("\""))<CR>gv :yank<CR>
        nmap \Y : silent call system("xclip ", getreg("\""))<CR>:echo "Yanked to clipboard: " . getreg("\"")<CR>
        nmap \y : silent call system("xclip ", getreg("0"))<CR>:echo "Yanked to clipboard: " . getreg("0")<CR>
        vmap \cy y: silent call system("xclip ", getreg("\""))<CR>:echo "Yanked to clipboard: " . getreg("\"")<CR>
    endif

    " Filetype Detect
    augroup filetypedetect
        au BufNewFile,BufRead afiedt.buf                              set filetype=sql
        au BufNewFile,BufRead /etc/httpd/conf/*.conf                  set filetype=apache
        au BufNewFile,BufRead /etc/httpd/conf.d/*.conf                set filetype=apache
        au BufNewFile,BufRead /etc/httpd/virtual/*.conf               set filetype=apache
        au BufNewFile,BufRead /usr/local/apache2/conf/*.conf          set filetype=apache
        au BufNewFile,BufRead /usr/local/apache2/conf/UMG_conf/*.conf set filetype=apache
        au BufNewFile,BufRead /etc/event.d/*                          set filetype=upstart
        au BufNewFile,BufRead */cfengine/*/inputs/*.conf              set filetype=cfengine
        au BufRead,BufNewFile *.js                                    set filetype=javascript.jquery
    augroup END

    " ZSH Brokenness
    au FileType zsh set formatoptions=croq
    au FileType sh set formatoptions-=t
    au FileType spec set formatoptions-=a

    au FileType perl :call MyPerlSettings()

    au FileType apache set nosmartindent preserveindent

    au FileType xml,xslt compiler xmllint " Enables :make for XML and HTML validation
    au FileType html compiler tidy  "           use :cn & :cp to jump between errors

    au FileType html,css,xhtml let html_use_css=1              "       for standards-compliant :TOhtml output
    au FileType html,css,xhtml let use_xhtml=1                 "       for standards-compliant :TOhtml output

    au FileType php let php_sql_query = 1
    au FileType php let php_htmlInStrings = 1
    au FileType php let php_folding = 1
    au FileType php let php_sync_method = 0

    "  Use enter to activate help jump points & display line numbers
    "   au FileType help set number     
    au FileType help nmap <buffer> <Return> <C-]>
    "   au FileType help nmap <buffer> <C-[> <C-O>
endif


"let html_number_lines = 0
let html_ignore_folding = 1


" -------------------------
"  REMAPPING
"  ------------------------
nmap <silent> <A-Up> :wincmd k<CR>
nmap <silent> <A-Down> :wincmd j<CR>
nmap <silent> <A-Left> :wincmd h<CR>
nmap <silent> <A-Right> :wincmd l<CR>

" this maps shift up and down to scroll
inoremap <esc>[1;2B <C-E>
inoremap <esc>[1;2A <C-Y>

"    prevents smartindent from being annoying with #
" inoremap # X<BS>#

map   <silent> <F1>    <Esc>
"map   <silent> <F2>    :DetectIndent<CR>
"map   <silent> <F3>    :Explore<CR>
"nmap  <silent> <F4>    :exe ":ptag ".expand("<cword>")<CR>
"map   <silent> <F6>    :copen<CR>
"map   <silent> <F7>    :cp<CR>
"map   <silent> <F8>    :cn<CR>
map   <silent> <F12>   :let &number=1-&number<Bar>set number?<CR>
"
imap  <silent> <F1>    <ESC>
"imap  <silent> <F2>    <Esc>:DetectIndent<CR>
"imap  <silent> <F3>    <Esc>:Explore<CR>
"imap  <silent> <F4>    <Esc>:exe ":ptag ".expand("<cword>")<CR>
"imap  <silent> <F6>    <Esc>:copen<CR>
"imap  <silent> <F7>    <Esc>:cp<CR>
"imap  <silent> <F8>    <Esc>:cn<CR>
imap  <silent> <F12>   :let &number=1-&number<Bar>set number?<CR>


"imap <F12> :set number! <CR> :set number?<CR>
"map <F12>  :set number! <CR> :set number?<CR>
map <F11>  :set paste! <CR> :set paste?<CR>
"map <F10>  :set wrap! <CR> :set wrap?<CR>
map <F9>   :set hls! <CR> :set hls?<CR>


" this one maps pastemode toggle to F11
set pastetoggle=<F11>

" <F10> do the line wrapping hoobla
function! RapNo()
   :set nowrap
   :set list
   :map <SILENT><F10> :call RapYes()<CR>
endfunction

" and back
function! RapYes()
   :set wrap
   :set nolist
   :set linebreak
   :set showbreak=-->\ 
   :map <silent><F10> :call RapNo()<CR>
endfunction

map <silent><F10> :call RapNo()<CR>

"" <F9> toggle hlsearch
"noremap <silent> <F9> :set hlsearch!<cr>
"
imap <C-w> <C-o><C-w>

vnoremap > >gv
vnoremap < <gv
vnoremap = =gv

" From vim.org
"  super wraping work around
nnoremap j gj
nnoremap k gk
vnoremap j gj
vnoremap k gk

nnoremap <Down> gj
nnoremap <Up> gk
vnoremap <Down> gj
vnoremap <Up> gk

noremap <C-j> gj
noremap <C-k> gk

" Move around in insert mode!!!
imap <C-j> <C-o>j
imap <C-k> <C-o>k
imap <C-l> <C-o>l
imap <C-h> <C-o>h

command! Hexmode call ToggleHex()
function! ToggleHex()
    " hex mode should be considered a read-only operation
    " save values for modified and read-only for restoration later,
    " and clear the read-only flag for now
    let l:modified=&mod
    let l:oldreadonly=&readonly
    let &readonly=0
    if !exists("b:editHex") || !b:editHex
        " save old options
        let b:oldft=&ft
        let b:oldbin=&bin
        " set new options
        setlocal binary " make sure it overrides any textwidth, etc.
        let &ft="xxd"
        " set status
        let b:editHex=1
        " switch to hex editor
        %!xxd
    else
        " restore old options
        let &ft=b:oldft
        if !b:oldbin
            setlocal nobinary
        endif
        " set status
        let b:editHex=0
        " return to normal editing
        %!xxd -r
    endif
    " restore values for modified and read only state
    let &mod=l:modified
    let &readonly=l:oldreadonly
endfunction

"if version >= 700
"   "  this line makes esc accept a completion
"   inoremap <silent><Esc>      <C-r>=pumvisible()?"\<lt>C-e>":"\<lt>Esc>"<CR>
"   
"   "  but i think it would do better to accept and go to normal mode
""
""inoremap <silent><Esc>      <C-r>=pumvisible()?"\<lt>C-e>":"\<lt>CR>"<CR><Esc>
"
"   inoremap <silent><CR>       <C-r>=pumvisible()?"\<lt>C-y>":"\<lt>CR>"<CR>
"   inoremap <silent><Down>     <C-r>=pumvisible()?"\<lt>C-n>":"\<lt>Down>"<CR>
"   inoremap <silent><Up>       <C-r>=pumvisible()?"\<lt>C-p>":"\<lt>Up>"<CR>
"   inoremap <silent><PageDown> <C-r>=pumvisible()?"\<lt>PageDown>\<lt>C-p>\<lt>C-n>":"\<lt>PageDown>"<CR>
"   inoremap <silent><PageUp>   <C-r>=pumvisible()?"\<lt>PageUp>\<lt>C-p>\<lt>C-n>":"\<lt>PageUp>"<CR> 
"endif
"
"" --------------
"  other

" space like more or less
nmap <space> <PageDown>
"nnoremap <c-space> <PageUp>

"   perl
let g:Perl_AuthorName      = 'Justin Hoppensteadt'
let g:Perl_AuthorRef       = 'JH'
let g:Perl_Email           = 'Justin.Hoppensteadt@umgtemp.com'
let g:Perl_Company         = 'Universal Music Group'

let g:BASH_AuthorName      = 'Justin Hoppensteadt'
let g:BASH_AuthorRef       = 'JH'
let g:BASH_Email           = 'Justin.Hoppensteadt@umgtemp.com'
let g:BASH_Company         = 'Universal Music Group'

let g:Lua_AuthorName      = 'Justin Hoppensteadt'
let g:Lua_AuthorRef       = 'JH'
let g:Lua_Email           = 'Justin.Hoppensteadt@umgtemp.com'
let g:Lua_Company         = 'Universal Music Group'

"" insert mode : autocomplete brackets and braces
"imap ( ()<Left>
"imap [ []<Left>
"imap { {}<Left>
""
"" visual mode : frame a selection with brackets and braces
"vmap ( d<Esc>i(<Esc>p
"vmap [ d<Esc>i[<Esc>p
"vmap { d<Esc>i{<Esc>p
"
"-------------------------------------------------------------------------------
" Fast switching between buffers
" The current buffer will be saved before switching to the next one.
" Choose :bprevious or :bnext
"-------------------------------------------------------------------------------
"
map  <silent> <s-tab>  <Esc>:if &modifiable && !&readonly &&
    \                            &modified <CR> :write<CR> :endif<CR>:bnext<CR>
imap  <silent> <s-tab>  <Esc>:if &modifiable && !&readonly &&
    \                            &modified <CR> :write<CR> :endif<CR>:bnext<CR>
"
"-------------------------------------------------------------------------------
" Leave the editor with Ctrl-q : Write all changed buffers and exit Vim
"-------------------------------------------------------------------------------
"nmap  <C-q>    :wqa<CR>
"
"-------------------------------------------------------------------------------
" Change the working directory to the directory containing the current file
"-------------------------------------------------------------------------------
"if has("autocmd")
"    autocmd BufEnter * :lcd %:p:h
"endif " has("autocmd")
"
colorscheme typofree
" vim:ft=vim:syn=vim:ts=4
