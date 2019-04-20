if exists('g:loaded_clear_fold_text')
	finish
endif
let g:loaded_clear_fold_text = 1

set foldtext=clear_fold_text#getText()
