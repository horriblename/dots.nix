setl shiftwidth=3  " (auto)indent size
setl tabstop=4     " liteal tab size
setl softtabstop=4
setl expandtab

setl textwidth=100
setl colorcolumn=100
setl formatoptions=jtoqnr
setl autoindent
setl comments=bn:>,bn:-,bn:+,b:*

" move line to beginning of next/prev section
nmap <buffer> <leader>md dd]]p
nmap <buffer> <leader>mu dd[[p
xmap <buffer> <leader>md d]]p
xmap <buffer> <leader>mu d[[p

inoremap <buffer> ``` ```<cr>```<up><End>
inoremap <buffer> $$<cr> $$<cr>$$<Esc>O
