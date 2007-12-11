"
" I might as well keep one of these
"
"  version 0.1

colorscheme metacosm 

set cursorline
set cursorcolumn

"===============================================================================
"==========  CUSTOMIZATION (gvimrc)  ===========================================
"===============================================================================
"
"-------------------------------------------------------------------------------
" Moving cursor to other windows
" 
" shift down   : change window focus to lower one (cyclic)
" shift up     : change window focus to upper one (cyclic)
" shift left   : change window focus to one on left
" shift right  : change window focus to one on right
"-------------------------------------------------------------------------------
"
nmap <s-down>   <c-w>w
nmap <s-up>     <c-w>W
nmap <s-left>   <c-w>h
nmap <s-right>  <c-w>l
"
"
"-------------------------------------------------------------------------------
"  some additional hot keys
"-------------------------------------------------------------------------------
"   S-F3  -  call gvim file browser
"-------------------------------------------------------------------------------
"
 map  <silent> <s-F3>       :browse confirm e<CR>
imap  <silent> <s-F3>  <Esc>:browse confirm e<CR>
"
"
"-------------------------------------------------------------------------------
" toggle insert mode <--> 'normal mode with the <RightMouse>-key
"-------------------------------------------------------------------------------
"
nmap    <RightMouse> <Insert>
imap    <RightMouse> <ESC>
"
"

