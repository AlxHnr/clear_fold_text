" Copyright (c) 2014 Alexander Heinrich <alxhnr@nudelpost.de> {{{
"
" This software is provided 'as-is', without any express or implied
" warranty. In no event will the authors be held liable for any damages
" arising from the use of this software.
"
" Permission is granted to anyone to use this software for any purpose,
" including commercial applications, and to alter it and redistribute it
" freely, subject to the following restrictions:
"
"    1. The origin of this software must not be misrepresented; you must
"       not claim that you wrote the original software. If you use this
"       software in a product, an acknowledgment in the product
"       documentation would be appreciated but is not required.
"
"    2. Altered source versions must be plainly marked as such, and must
"       not be misrepresented as being the original software.
"
"    3. This notice may not be removed or altered from any source
"       distribution.
" }}}

" Escapes all magic Regex characters in 'pat' and returns it.
function! s:regex_escape(pat) " {{{
	return escape(a:pat, '^(.*?"[+-~]<@!:>|{=\/&%@#})$' . "'")
endfunction " }}}

" This function strips out all comment strings and markers from 'line'.
function! s:strip_line(line) " {{{
	let l:comment_pattern = s:regex_escape(split(&commentstring, '%s')[0])
	let l:line =
		\	substitute(a:line, '\v^\s*(' . l:comment_pattern . '*)?\s*', '', 'g')

	if &foldmethod == 'marker'
		let l:line = substitute(l:line, '\v(' . l:comment_pattern . ')?\s*'
			\	. s:regex_escape(split(&foldmarker, ',')[0]) . '\s*$', '', 'g')
	endif

	return l:line
endfunction " }}}

function! clear_fold_text#getText() " {{{
	let l:lines_folded = v:foldend - v:foldstart + 1
	let l:linecount_padding = 3
	let l:prefix = '—▶ '

	" Get the next line, if the current is empty.
	let l:line = s:strip_line(getline(v:foldstart))
	if empty(l:line)
		let l:line = s:strip_line(getline(v:foldstart + 1))
	endif

	" Format the line properly.
	if empty(l:line)
		let l:line = ' folded'
	elseif l:line =~ '\v^\s*[\{\[]\s*$'
		let l:line = ' folded'
		let l:prefix = '└▶ '
		let l:linecount_padding = 1
	else
		let l:line = ': ' . l:line
	endif

	" Pad line count. E.g. '12' -> '  12'.
	let l:lines_folded = repeat(' ', l:linecount_padding -
		\	len(l:lines_folded)) . l:lines_folded

	return repeat(' ', indent(v:foldstart)) . l:prefix . l:lines_folded
		\	. ' lines' . l:line . repeat(' ', winwidth('.'))
endfunction " }}}
