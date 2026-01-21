setlocal expandtab tabstop=2
setlocal cpoptions+=M

" count sections backward
nnoremap <buffer> [[ :call search('\C^\l\w*\>', 'Wsb')<CR>
" count sections forward
nnoremap <buffer> ]] :call search('\C^\l\w*\>', 'Ws')<CR>
