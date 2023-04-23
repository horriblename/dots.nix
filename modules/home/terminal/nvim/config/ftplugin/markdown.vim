setl tabstop=4
setl shiftwidth=3
setl softtabstop=3
setl expandtab

setl textwidth=100
setl colorcolumn=100
setl formatoptions=jtoqnr
setl autoindent
setl comments=bn:>,bn:-,bn:+,b:*

setl indentexpr=b:MarkdownIndent()

" if exists("MarkdownIndent")
	" fu b:MarkdownIndent()
	" 	if v:lnum == 1
	" 		return indent(v:lnum)
	" 	endif
	"
	" 	let prev = getline(v:lnum)
	" 	let x=  matchend("^\s*\d\+[\]:.)}\t ]\s*", prev, 0, 1)
	"
	" endfu
" endif

" move line to beginning of next/prev section
nmap <leader>md dd]]p
nmap <leader>mu dd[[p
xmap <leader>md d]]p
xmap <leader>mu d[[p

inoremap ``` ```<cr>```<up><Esc>A
inoremap $$<cr> $$<cr>$$<Esc>O
