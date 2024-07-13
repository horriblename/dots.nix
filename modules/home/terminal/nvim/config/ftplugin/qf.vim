let &l:errorformat = '%f|%l col %c| %m,%f|%l col %c-%k| %m'

nnoremap <buffer> <localleader>m :setl modifiable<CR>
nnoremap <buffer> <c-s> <cmd>if !&modified <bar> echo 'not changed' <bar> else <bar> cgetbuffer <bar> set nomodified <bar> echo 'Quickfix list updated' <bar> endif<CR>
