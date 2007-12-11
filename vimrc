" Justin's vimrc

" 
"  General Operation

" vimrc-1.7

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
set expandtab
set textwidth=80
set formatoptions=croqa
set linebreak
set nolist
set preserveindent
set shiftwidth=4
set showbreak=-->\ 
set smartindent
set smarttab
"set softtabstop=4
set tabstop=4
set wrap

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

    " DetectIndent
    "let g:detectindent_preferred_expandtab = 1  
    "let g:detectindent_preferred_indent = 4 
    "au BufReadPost * :DetectIndent

    " ZSH Brokenness
    au FileType zsh set formatoptions=croq

    " STOLEN!!
    au FileType crontab set nobackup 

    au FileType xml,xslt compiler xmllint " Enables :make for XML and HTML validation
    au FileType html compiler tidy  "           use :cn & :cp to jump between errors

    let html_use_css=1              "       for standards-compliant :TOhtml output
    let use_xhtml=1                 "       for standards-compliant :TOhtml output

    "  Use enter to activate help jump points & display line numbers
    "   au FileType help set number     
    au FileType help nmap <buffer> <Return> <C-]>
    "   au FileType help nmap <buffer> <C-[> <C-O>

    augroup filetypedetect
        au BufNewFile,BufRead afiedt.buf      setf sql
    augroup END

   	set cpt=.,k,w,b,t,i
   	"set cpt=.,w,b,t,i
   	au FileType perl set cpt=.,w,b
   	if version >= 700
   		au FileType perl set indentexpr=
   		au FileType perl set noautoindent
   	endif
endif



" -------------------------
"  REMAPPING
"  ------------------------

" this maps shift up and down to scroll
inoremap <esc>[1;2B <C-E>
inoremap <esc>[1;2A <C-Y>

"	prevents smartindent from being annoying with #
inoremap # X<BS>#

" this nice little oneliner toggles number on <F12>
"noremap <silent> <F12> :set number!<cr> 
"
"
"-------------------------------------------------------------------------------
"  some additional hot keys
"-------------------------------------------------------------------------------
"    F2   -  DetectIndent
"    F3   -  call file explorer Ex
"    F4   -  show tag under curser in the preview window (tagfile must exist!)
"    F6   -  list all errors           
"    F7   -  display previous error
"    F8   -  display next error   
"    F12  -  toggle line numbers
"  S-Tab  -  Fast switching between buffers (see below)
"    C-q  -  Leave the editor with Ctrl-q (see below)
"-------------------------------------------------------------------------------
"
map   <silent> <F1>    <Esc>
map   <silent> <F2>    :DetectIndent<CR>
map   <silent> <F3>    :Explore<CR>
nmap  <silent> <F4>    :exe ":ptag ".expand("<cword>")<CR>
map   <silent> <F6>    :copen<CR>
map   <silent> <F7>    :cp<CR>
map   <silent> <F8>    :cn<CR>
map   <silent> <F12>   :let &number=1-&number<CR>
"
imap  <silent> <F1>    <ESC>
imap  <silent> <F2>    <Esc>:DetectIndent<CR>
imap  <silent> <F3>    <Esc>:Explore<CR>
imap  <silent> <F4>    <Esc>:exe ":ptag ".expand("<cword>")<CR>
imap  <silent> <F6>    <Esc>:copen<CR>
imap  <silent> <F7>    <Esc>:cp<CR>
imap  <silent> <F8>    <Esc>:cn<CR>
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

" these make completion more sane
" use arrows and whatnot

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
let g:Perl_Email           = 'justin@buzznet.com'
let g:Perl_Company         = 'Buzznet, Inc.'

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
