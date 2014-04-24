"   Spine vim syntax
"   Justin Hoppensteadt <Justin.Hoppensteadt@ticketmaster.com>
"


if exists("b:current_syntax")
    finish
endif


syntax case match
syntax case ignore


syntax case match
syntax keyword spineConditional IF ELSE ELSIF END MATCH OR AND UNLESS SWITCH CASE SET FOREACH contained
syntax match spineFunction +\<\(c_\|\)\(arch\|virtual_type\|hostname_[fts]\|version\|is_virtual\|is_xenvm\|classcommon\|host\|instance\|product\|cluster\|getval\|match\|arch\|bu\|c\|class\|cluster\|search\|ctype\|distro\(\|_version\|_name\|_release\)\)\>+ contained

syntax region spineString start=+\<(+            end=+)\>+ contained extend
syntax region spineString start=+"+ skip=+\\"+ end=+"+ contained contains=spineStringSpecial
syntax region spineString start=+'+ skip=+\\'+ end=+'+ contained contains=spineStringSpecial


syntax match spineTest  +.*+ contained

syntax match spineCodeOps +\<[=^;]\>+ contained
syntax match spineCodeDelimt +\[%+ contained
syntax match spineCodeDelimt +%\]+ contained
syntax region spineCodeComment start="\[%-" end="-%\]" contained
syntax region spineCodeComment start="#" end="$" contained
syntax region spineCode start="\[%" end="%\]" fold transparent keepend contains=spineConditional,spineString,spineFunction,spineCodeDelimt,spineCodeComment,spineCodeOps


let b:current_syntax = "spine"
hi def link spineConditional    Special
hi def link spineString         String
hi def link spineStringSpecial  Special
hi def link spineSpecialString  Special
hi def link spineFunction       Function
hi def link spineTest           Todo
hi def link spineTags           Special
hi def link spineCode           Statement
hi def link spineCodeDelimt     PreProc
hi def link spineCodeComment    Comment
hi def link spineCodeOps        Operator





"syntax match spineStringSpecial +[\\\"\[\]&`+*.,;=%~!?@#$<>|)(-]+ contained
"syntax match spineSpecialString    "\\\%(\o\{1,3}\|x\%({\x\+}\|\x\{1,2}\)\|c.\|[^cx]\)" contained extend
"syntax match spineSpecialStringU2  "\\." extend contained contains=NONE
"syntax match spineSpecialStringU   "\\\\" contained
"syntax match spineSpecialMatch     "\\[1-9]" contained extend
"syntax match spineSpecialMatch     "\\g\%(\d\+\|{\%(-\=\d\+\|\h\w*\)}\)" contained
"syntax match spineSpecialMatch     "\\k\%(<\h\w*>\|'\h\w*'\)" contained
"syntax match spineSpecialMatch     "{\d\+\%(,\%(\d\+\)\=\)\=}" contained
"syntax match spineSpecialMatch     "\[[]-]\=[^\[\]]*[]-]\=\]" contained extend
"syntax match spineSpecialMatch     "[+*()?.]" contained
"syntax match spineSpecialMatch     "(?[#:=!]" contained
"syntax match spineSpecialMatch     "(?[impsx]*\%(-[imsx]\+\)\=)" contained
"syntax match spineSpecialMatch     "(?\%([-+]\=\d\+\|R\))" contained
"syntax match spineSpecialMatch     "(?\%(&\|P[>=]\)\h\w*)" contained
"
