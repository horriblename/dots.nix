" ' %\?%\w%#' are regex in errorformat to skip error level as handling
" everything would cause a combinatorial explosion.
let &l:errorformat = join([
	\ '||%m',
	\ '%f|%\w%#|%m',
	\ '%f|%l %\?%\w%#|%m',
	\ '%f|%l col %c %\?%\w%#|%m',
	\ '%f|%l col %c-%k %\?%\w%#|%m',
	\], ',')

nnoremap <buffer> <localleader>m :setl modifiable<CR>
nnoremap <buffer> <c-s> <cmd>if !&modified <bar> echo 'not changed' <bar> else <bar> cgetbuffer <bar> set nomodified <bar> echo 'Quickfix list updated' <bar> endif<CR>
