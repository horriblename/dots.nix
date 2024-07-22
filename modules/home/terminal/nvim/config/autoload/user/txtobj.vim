" Credits: https://vim.fandom.com/wiki/Indent_text_object
" Licensed under CC-BY-SA (https://www.fandom.com/licensing)

function! user#txtobj#FindIndentBegin(inner)
	let i = indent(line(".")) - &shiftwidth * (v:count1 - 1)
	let i = i < 0 ? 0 : i
	if getline(".") =~ "^\\s*$"
		return
	endif
	let p = line(".") - 1
	let nextblank = getline(p) =~ "^\\s*$"
	while p > 0 && (nextblank || indent(p) >= i )
		-
		let p = line(".") - 1
		let nextblank = getline(p) =~ "^\\s*$"
	endwhile
	if (!a:inner)
		-
	endif
	call cursor(line('.'), 0)
endfunction

function! user#txtobj#FindIndentEnd(inner)
	let lastline = line("$")
	let p = line(".") + 1
	let nextblank = getline(p) =~ "^\\s*$"
	while p <= lastline && (nextblank || indent(p) >= i )
		+
		let p = line(".") + 1
		let nextblank = getline(p) =~ "^\\s*$"
	endwhile
	if (!a:inner)
		+
	endif
	call cursor(line('.'), 0)
endfunction

function! user#txtobj#IndentTextObj(inner)
	let curline = line(".")
	call user#txtobj#FindIndentBegin(inner)
	normal! 0V
	call cursor(curline, 0)
	call user#txtobj#FindIndentEnd(inner)
	normal! $
endfunction
