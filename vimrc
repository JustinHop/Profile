" Justin's vimrc

" 
"  General Operation

" vimrc-1.8

set nocompatible
set backspace=2
set ttyfast

if has("unix")
    set backup
    set backupdir=~/.undo
endif

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
"set cul

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
    set foldminlines=5
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
if &t_Co || has("gui_running") && ( $TERM != "screen.linux")
    syntax on
    set t_Co=256
endif

"
"  This section checks for an environmental variable $VIM_COLOR
"     to set the colorscheme, if not do some 1/2 assed logic
"
if $VIM_COLOR 
    exec ":colorscheme $VIM_COLOR"
else
    colorscheme elflord
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
    colorscheme wuye
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

    " ZSH Brokenness
    au FileType zsh set formatoptions=croq
    au FileType sh set formatoptions-=t
    au FileType spec set formatoptions-=a

    au FileType perl :call MyPerlSettings()

    au FileType apache set nosmartindent

    " STOLEN!!
    au FileType crontab set nobackup 

    au FileType xml,xslt compiler xmllint " Enables :make for XML and HTML validation
    au FileType html compiler tidy  "           use :cn & :cp to jump between errors

    let html_use_css=1              "       for standards-compliant :TOhtml output
    let use_xhtml=1                 "       for standards-compliant :TOhtml output

    " vim -b : edit binary using xxd-format!
"    augroup Binary
"        au!
"        au BufReadPre *.bin,*.hex setlocal binary
"        au BufReadPost *
"                    \ if &binary | exe "Hexmode" | endif
"        au BufWritePre *
"                    \ if exists("b:editHex") && b:editHex && &binary |
"                    \  exe "%!xxd -r" |
"                    \ endif
"        au BufWritePost *
"                    \ if exists("b:editHex") && b:editHex && &binary |
"                    \  exe "%!xxd" |
"                    \  exe "set nomod" |
"                    \ endif
"    augroup END

    "  Use enter to activate help jump points & display line numbers
    "   au FileType help set number     
    au FileType help nmap <buffer> <Return> <C-]>
    "   au FileType help nmap <buffer> <C-[> <C-O>

    augroup filetypedetect
        au BufNewFile,BufRead afiedt.buf      setf sql
    augroup END

   	"set cpt=.,w,b,t,i
   	"au FileType perl set cpt=.,w,b
    "if version >= 700
    "	au FileType perl set indentexpr=
    "	au FileType perl set noautoindent
    "endif
endif



" -------------------------
"  REMAPPING
"  ------------------------

" this maps shift up and down to scroll
inoremap <esc>[1;2B <C-E>
inoremap <esc>[1;2A <C-Y>

"	prevents smartindent from being annoying with #
inoremap # X<BS>#

map   <silent> <F1>    <Esc>
"map   <silent> <F2>    :DetectIndent<CR>
"map   <silent> <F3>    :Explore<CR>
"nmap  <silent> <F4>    :exe ":ptag ".expand("<cword>")<CR>
"map   <silent> <F6>    :copen<CR>
"map   <silent> <F7>    :cp<CR>
"map   <silent> <F8>    :cn<CR>
map   <silent> <F12>   :let &number=1-&number<CR>
"
imap  <silent> <F1>    <ESC>
"imap  <silent> <F2>    <Esc>:DetectIndent<CR>
"imap  <silent> <F3>    <Esc>:Explore<CR>
"imap  <silent> <F4>    <Esc>:exe ":ptag ".expand("<cword>")<CR>
"imap  <silent> <F6>    <Esc>:copen<CR>
"imap  <silent> <F7>    <Esc>:cp<CR>
"imap  <silent> <F8>    <Esc>:cn<CR>
imap  <silent> <F12>   :let &number=1-&number<CR>

" this one maps pastemode toggle to F11
set pastetoggle=<F11>

" <F10> do the line wrapping hoobla
function! RapNo()
   :set nowrap
   :set list
   :map <F10> :call RapYes()<CR>
endfunction

" and back
function! RapYes()
   :set wrap
   :set nolist
   :set linebreak
   :set showbreak=>>>\ 
   :map <F10> :call RapNo()<CR>
endfunction

map <F10> :call RapNo()<CR>

" <F9> toggle hlsearch
noremap <silent> <F9> :set hlsearch!<cr>

imap <C-w> <C-o><C-w>

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

command Hexmode call ToggleHex()
function ToggleHex()
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

" Highlight commom java syntax
let java_highlight_java_lang_ids=1
" highlight system.out
let java_highlight_debug=1
" Mark Parnthesis
hi link javaParen Comment
" Keep scope in memory
let java_minlines=50

"   perl
let g:Perl_AuthorName      = 'Justin Hoppensteadt'
let g:Perl_AuthorRef       = 'JH'
let g:Perl_Email           = 'Justin.Hoppensteadt@umgtemp.com'
let g:Perl_Company         = 'Universal Music Group'

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
nmap  <C-q>    :wqa<CR>
"
"-------------------------------------------------------------------------------
" Change the working directory to the directory containing the current file
"-------------------------------------------------------------------------------
"if has("autocmd")
"    autocmd BufEnter * :lcd %:p:h
"endif " has("autocmd")
"
" vim:ft=vim:syn=vim:ts=4
