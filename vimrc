" Justin's vimrc
" $Id$

"
"  General Operation

" vimrc-2


" Vim Profiles
let g:profiles_default = ['lib', 'base']
exec profiles#init()
call pathogen#helptags()

let Tlist_Use_Right_Window = 1
let g:airline#extensions#tabline#enabled = 1

set backspace=2
set ttyfast

set hidden

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
set noshowmode
set showcmd
set lazyredraw

" Status Line
set statusline=#%n\ %<%F%m%r\ %w\ %y\ \ <%{&fileencoding},%{&fileformat}>%=<%{&tabstop}:%{&softtabstop}:%{&shiftwidth}:%{&expandtab}>%<\ \ \ %l,%c%V\ of\ %L\ \ \ %P
let g:airline_section_y='%{airline#util#wrap(airline#parts#ffenc(),0)}%{&tabstop}:%{&softtabstop}:%{&shiftwidth}:%{&expandtab}'

if version >= 700
  "  Virtual Editing
  set virtualedit=block,onemore
endif

"  Indenting Formating
"  Being set through plugin now
set autoindent
set copyindent
set preserveindent
set smartindent
set textwidth=80
set smarttab
set softtabstop=4
set shiftwidth=4
set tabstop=4
set expandtab
set formatoptions=roq
set list
set showbreak=-->\
set wrap
set linebreak

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
  let perl_extended_vars=1

  compiler perl
  "colorscheme wuye
endfunction

function! DoTitle()
  if &term == "screen"
    let &titlestring=expand("%:t")
    set t_ts=k
    set t_fs=\
    set title
  endif
endfunction

function! WriteBackupPath(originalFilespec, isQueryOnly)
  let l:WriteBackupRCPathVar=fnamemodify($HOME . '/backup' . expand("%:p"), ":p:h")
  "echo a:originalFilespec
  "let WriteBackupRCPathVar=fnamemodify($HOME . '/backup' . a:originalFilespec, ":p:h")
  if a:isQueryOnly == 1
    if ! isdirectory(l:WriteBackupRCPathVar)
      call mkdir(l:WriteBackupRCPathVar, "p")
    endif
  endif
  return l:WriteBackupRCPathVar
endfunction
let g:WriteBackup_BackupDir =function('WriteBackupPath')

function! EnableBackupExists()
  if ! (exists('g:EnabledBackup'))
    if g:DoBackups == 1
      execute "silent! normal :LoadProfiles backup \<CR>"
      execute "silent! normal :WriteBackup \<CR>"
    endif
    let g:EnabledBackup = 1
  endif
endfunction

function! EnableBackupNew()
  if ! (exists('g:EnabledBackup'))
    if g:DoBackups == 1
      execute "silent! normal :LoadProfiles backup \<CR>"
    endif
    let g:EnabledBackup = 1
  endif
endfunction

function! DoColors()
  set background=dark
  let g:solarized_termcolors=256
  colorscheme elflord
  if exists('g:loaded_solarized_menu')
    colorscheme solarized
  elseif filereadable($HOME . '/.vim/colors/badwolf.vim')
    colorscheme badwolf
  endif
endfunction

filetype on
filetype plugin on
filetype indent on

set directory=~/tmp

if has("autocmd")
  filetype plugin indent on
  "jumpback
  au BufReadPost *
        \ if line("'\"") > 0 && line ("'\"") <= line("$") |
        \   exe "normal g'\"" |
        \ endif

  " purdy colors
  set background=dark
  let g:solarized_termcolors=16
  colorscheme solarized


  " yank to clipboard
  if executable("xclip")
    "vnoremap y  :yank<CR>:call system("xclip -i", getreg("\""))<CR>gv :yank<CR>
    "nmap <leader>Y : silent call system("xclip ", getreg("\""))\<CR>:echo "Yanked to clipboard: " . getreg("\"")<CR>
    "nmap <leader>y : silent call system("xclip ", getreg("0"))\<CR>:echo "Yanked to clipboard: " . getreg("0")<CR>
    "vmap <leader>cy y: silent call system("xclip ", getreg("\""))\<CR>:echo "Yanked to clipboard: " . getreg("\"")<CR>
    nmap <leader>Y : silent call system("xclip ", getreg("\""))\<CR>
    nmap <leader>y : silent call system("xclip ", getreg("0"))\<CR>
    vmap <leader>cy y: silent call system("xclip ", getreg("\""))\<CR>
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
    au BufRead,BufNewFile /etc/nginx/*                            set filetype=nginx
    au BufRead,BufNewFile */syseng-rubix-config/*                 set filetype=spine
    au BufRead,BufNewFile */syseng-rubix-config/*/svn-commit.tmp  set filetype=svn
  augroup END

  let g:DoBackups = 1
  au BufNewFile,BufRead ~/backup/* let g:DoBackups = 0
  au BufNewFile * call EnableBackupNew()
  au BufRead * call EnableBackupExists()

  au BufReadPost * silent! call ReadUndo()
  au BufWritePost * silent! call WriteUndo()
  func ReadUndo()
    if filereadable($HOME . '/backup/undo' . expand('%:p'))
      rundo ~/backup/undo%:p
    endif
  endfunc
  func WriteUndo()
    let dirname = $HOME . '/backup/undo' . expand('%:p:h')
    if !isdirectory(dirname)
      call mkdir(dirname, "p")
    endif
    wundo ~/backup/undo%:p
  endfunc


  au FileType nerdtree setlocal nofoldenable

  " ZSH Brokenness
  au FileType zsh set formatoptions=croq
  au FileType sh set formatoptions-=t
  au FileType spec set formatoptions-=a

  "au FileType perl :call MyPerlSettings()

  au BufEnter * :call DoTitle()

  au FileType apache set nosmartindent preserveindent

  au FileType xml,xslt compiler xmllint " Enables :make for XML and HTML validation
  au FileType html compiler tidy  "           use :cn & :cp to jump between errors

  au FileType html,css,xhtml let html_use_css=1              "       for standards-compliant :TOhtml output
  au FileType html,css,xhtml let use_xhtml=1                 "       for standards-compliant :TOhtml output

  "au FileType html,css,xhtml,php,javascript colorscheme cleanphp

  " au FileType php let php_sql_query = 1
  au BufRead,BufNewFile *.php		set indentexpr= | set smartindent
  au FileType php let php_htmlInStrings = 1
  au FileType php let php_folding = 2
  au FileType php let php_sync_method = 0
  au FileType php let php_no_ShortTags = 1

  "  Use enter to activate help jump points & display line numbers
  "   au FileType help set number
  au FileType help nmap <buffer> <Return> <C-]>
  "   au FileType help nmap <buffer> <C-[> <C-O>
endif

" -------------------------
"  REMAPPING
"  ------------------------
nmap <silent> <A-Up> :wincmd k<CR>
nmap <silent> <A-Down> :wincmd j<CR>
nmap <silent> <A-Left> :wincmd h<CR>
nmap <silent> <A-Right> :wincmd l<CR>

nmap <silent> <leader>t :NERDTreeToggle<CR>
nmap <silent> <leader>T :TlistToggle<CR>

if has("gui_running")
  map <silent>  <S-Insert>  "+p
  imap <silent>  <S-Insert>  <Esc>"+pa
endif

" this maps shift up and down to scroll
inoremap <esc>[1;2B <C-E>
inoremap <esc>[1;2A <C-Y>

"    prevents smartindent from being annoying with #
" inoremap # X<BS>#

map   <silent> <F1>    <Esc>
map   <silent> <F2>    :GundoToggle<CR>
map   <silent> <F3>    :TlistToggle<CR>
"nmap  <silent> <F4>    :exe ":ptag ".expand("<cword>")<CR>
"map   <silent> <F6>    :copen<CR>
"map   <silent> <F7>    :cp<CR>
"map   <silent> <F8>    :cn<CR>
map   <silent> <F12>   :let &number=1-&number<Bar>set number?<CR>

imap  <silent> <F1>    <ESC>
imap  <silent> <F2>    <Esc>:GundoToggle<CR>
imap  <silent> <F3>    <Esc>:TlistToggle<CR>
"imap  <silent> <F4>    <Esc>:exe ":ptag ".expand("<cword>")<CR>
"imap  <silent> <F6>    <Esc>:copen<CR>
"imap  <silent> <F7>    <Esc>:cp<CR>
"imap  <silent> <F8>    <Esc>:cn<CR>
imap  <silent> <F12>   :let &number=1-&number<Bar>set number?<CR>


"imap <F12> :set number! <CR> :set number?<CR>
"map <F12>  :set number! <CR> :set number?<CR>
"map <F11>  :set paste! <CR> :set paste?<CR>
"map <F10>  :set wrap! <CR> :set wrap?<CR>
map <F9>   :set hls! <CR> :set hls?<CR>


" this one maps pastemode toggle to F11
set pastetoggle=<F11>

" <F10> do the line wrapping hoobla
if !exists("*ToggleWrap")
  function ToggleWrap()
    set wrap!
    set list!
    set linebreak!
  endfunction
  map <silent><F10> :call ToggleWrap()<CR>
  map! <silent><F10> ^[:call ToggleWrap()<CR>
endif

noremap!  <BS>
vnoremap  <BS>
inoremap  <BS>
cnoremap  <BS>

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

command! Hexmode call ToggleHex()

if !exists("*ToggleHex")
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
endif

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
nmap <space> mz<PageDown>
"nnoremap <c-space> <PageUp>

"   perl
let g:Perl_AuthorName      = 'Justin Hoppensteadt'
let g:Perl_AuthorRef       = 'JH'
let g:Perl_Email           = 'Justin.Hoppensteadt@ticketmaster.com'
let g:Perl_Company         = 'Live Nation'

let g:BASH_AuthorName      = 'Justin Hoppensteadt'
let g:BASH_AuthorRef       = 'JH'
let g:BASH_Email           = 'Justin.Hoppensteadt@ticketmaster.com'
let g:BASH_Company         = 'Live Nation'

let g:Lua_AuthorName      = 'Justin Hoppensteadt'
let g:Lua_AuthorRef       = 'JH'
let g:Lua_Email           = 'Justin.Hoppensteadt@ticketmaster.com'
let g:Lua_Company         = 'Live Nation'

let g:spec_chglog_packager = 'Justin Hoppensteadt <justin.hoppensteadt@ticketmaster.com>'

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
"map  <silent> <s-tab>  <Esc>:if &modifiable && !&readonly &&
"      \                            &modified <CR> :write<CR> :endif<CR>:bnext<CR>
"imap  <silent> <s-tab>  <Esc>:if &modifiable && !&readonly &&
"      \                            &modified <CR> :write<CR> :endif<CR>:bnext<CR>
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
if !exists("*Backspace")
  func Backspace()
    if col('.') == 1
      if line('.')  != 1
        return  "\<ESC>kA\<Del>"
      else
        return ""
      endif
    else
      return "\<Left>\<Del>"
    endif
  endfunc
  inoremap <silent> <BS> <c-r>=Backspace()<CR>
endif

if !exists("*WordProcessorMode")
  func! WordProcessorMode()
    setlocal formatoptions=1
    setlocal noexpandtab
    map j gj
    map k gk
    setlocal spell spelllang=en_us
    "  set thesaurus+=/Users/sbrown/.vim/thesaurus/mthesaur.txt
    set complete+=s
    set formatprg=par
    setlocal wrap
    setlocal linebreak
  endfu
  com! WP call WordProcessorMode()
endif

