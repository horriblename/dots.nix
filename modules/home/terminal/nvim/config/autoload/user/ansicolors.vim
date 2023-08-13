let g:AnsiTermColors = {
			\ "red":     "\\x1b[31m",
			\ "green":   "\\x1b[32m",
			\ "orange":  "\\x1b[33m",
			\ "blue":    "\\x1b[34m",
			\ "magenta": "\\x1b[35m",
			\ "aqua":    "\\x1b[26m",
			\ "grey":    "\\x1b[27m",
			\ "reset":   "\\x1b[0m",
			\ }

fu user#ansicolors#AnsiColorComp(lead, b, c) abort
	if a:lead ==# ''
		return keys(g:AnsiTermColors)
	endif
	return keys(g:AnsiTermColors)->matchfuzzy(a:lead)
endfu

fu user#ansicolors#InsertAnsiTermColor(color) abort
	let line=getline('.')
	let col=getcurpos()[2]
	let clr=g:AnsiTermColors[a:color]
	call setline('.', line[:col-1] . clr . line[col:])
	call cursor(0, col+len(clr))
endfu

