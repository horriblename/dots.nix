setl shiftwidth=3  " (auto)indent size
setl tabstop=4     " liteal tab size
setl softtabstop=4
setl expandtab

setl textwidth=80
setl formatoptions=jtoqnr
setl autoindent
setl comments=bn:>,bn:-,bn:+,b:*

" move line to beginning of next/prev section
nmap <buffer> <localleader>md dd]]p
nmap <buffer> <localleader>mu dd[[p
xmap <buffer> <localleader>md d]]p
xmap <buffer> <localleader>mu d[[p

inoremap <buffer> ``` ```<cr>```<up><End>
inoremap <buffer> $$<cr> $$<cr>$$<Esc>O
