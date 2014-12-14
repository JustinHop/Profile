" Hostname/ip resolving plugin
" Last Change:	11 July 2008
" Maintainer:	Stanisław Pitucha <viraptor@gmail.com>
" License:	This file is placed in the public domain.

if exists("loaded_resolve") || &cp
  finish
endif

function! s:GetCurrentAddress()
	let addr = matchstr(expand('<cWORD>'), '\([0-9]\+\.\)\{3\}[0-9]\+\|\([a-zA-Z0-9_-]\+\.\)\+[a-zA-Z]\+')
	if ! len(addr)
		throw 'no address found under cursor'
	endif

	return addr
endfunction

function! s:GetResolveResponse(srv, addr)
	let line = 'host '
	if a:srv != ''
		let line .= '-t '.a:srv.' _sip._udp.'
	endif

	let line .= a:addr
	let result = system(line)

	return result
endfunction

function! s:ResolveCurrent(srv)
	let addr = s:GetCurrentAddress()
	let result = s:GetResolveResponse(a:srv, addr)

	return result
endfunction

function! s:ResolveSubstitute(srv)
	let addr = s:GetCurrentAddress()
	let results = s:GetResolveResponse(a:srv, addr)
	let resultlines = split(results, "\n")

	if len(resultlines) > 1
		echo "Error: too many addresses to substitute:\n".results
		return
	endif
	
	let result = resultlines[0]
	
	let m = matchlist(result, '^.* \(has address\|domain name pointer\) \(.*[^.]\)\.\?$')
	if len(m) < 3
		echo 'Error: cannot resolve '.addr
		return
	endif
	
	call search(escape(addr, '.'), 'b')
	
	let rsave = @r
	let @r = m[2]
	execute 'normal "r[pl'.len(addr).'x'
	let @r = rsave
endfunction

noremap <unique> <script> <Plug>ResolveCurrentA <SID>ResolveCurrentDefault
noremap <unique> <script> <Plug>ResolveCurrentSRV <SID>ResolveCurrentSRV
noremap <unique> <script> <Plug>ResolveSubstituteA <SID>ResolveSubstituteDefault
noremap <unique> <script> <Plug>ResolveSubstituteSRV <SID>ResolveSubstituteSRV
noremap <SID>ResolveCurrentDefault :echo <SID>ResolveCurrent('')<CR>
noremap <SID>ResolveCurrentSRV :echo <SID>ResolveCurrent('srv')<CR>
noremap <SID>ResolveSubstituteDefault :call <SID>ResolveSubstitute('')<CR>
noremap <SID>ResolveSubstituteSRV :call <SID>ResolveSubstitute('srv')<CR>

if !hasmapto('<Plug>ResolveCurrentA')
	map <unique> <Leader>re <Plug>ResolveCurrentA
endif
if !hasmapto('<Plug>ResolveCurrentSRV')
	map <unique> <Leader>rs <Plug>ResolveCurrentSRV
endif
if !hasmapto('<Plug>ResolveSubstituteA')
	map <unique> <Leader>rE <Plug>ResolveSubstituteA
endif
if !hasmapto('<Plug>ResolveSubstituteSRV')
	map <unique> <Leader>rS <Plug>ResolveSubstituteSRV
endif

let loaded_resolve = 1
