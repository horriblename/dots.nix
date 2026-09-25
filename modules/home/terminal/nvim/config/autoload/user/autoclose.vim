" Autoclose right parenthesis
" @usage: 
"	inoremap <expr> ) user#autoclose#closeRight(')')
fu! user#autoclose#CloseRight(c) abort
	return strpart(getline('.'), col('.')-1, 1) == a:c ? "\<Right>" : a:c
endfu

" Insert a 'symmetric' symbol, such as quotes
" @usage:
"	inoremap <expr> ' user#autoclose#InsertSymmetric("'")
fu! user#autoclose#InsertSymmetric(c) abort
	return  strpart(getline('.'), col('.')-1, 1) == a:c ? "\<Right>" : a:c.a:c."\<Left>"
endfu

" returns '' if not found
fu! user#autoclose#getClosing(open)
	if a:open == '{' | return '}'
	elseif a:open == '(' | return ')'
	elseif a:open == '[' | return ']'
	elseif a:open == '<' | return '>'
	endif
endfu
