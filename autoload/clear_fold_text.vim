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

" set a new fold text.
function! clear_fold_text#getText() " {{{
	let l:lines_folded = v:foldend - v:foldstart + 1
	let l:lines_folded = repeat(' ', 3 - len(l:lines_folded)) . l:lines_folded

	let l:indention = indent(v:foldstart)
	let l:line = getline(v:foldstart)
	let l:prefix = '—▶ '

	" if the line is the beginning of a multiline C comment, that is empty,
	" display the next line.
	if line =~ '^\s*\/\**\s*$'
		let line = getline(v:foldstart + 1)
		let line = ': ' . substitute(line, '^\s*', '', 1)
	elseif line =~ '^\s*\/\**\s*'
		let line = ': ' . substitute(line, '^\s*\/\**\s*', '', 1)
	elseif line =~ '^\s*.\?\s*$'
		let line = ' folded'
		let l:prefix = '└▶ '
	elseif line =~ '{{{$'
		let line = ': ' . substitute(line, '^"*\s*\(.*\){{{$', '\1', 1)
	else
		let line = ': ' . substitute(line, '^\s*', '', 1)
	endif

	return repeat(' ', indention) . prefix . lines_folded . ' lines' .  line
		\	. repeat(' ', winwidth('.'))
endfunction " }}}
