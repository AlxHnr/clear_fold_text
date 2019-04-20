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
