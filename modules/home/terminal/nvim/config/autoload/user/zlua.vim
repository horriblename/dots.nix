fu user#zlua#chdir(pattern) abort
	let zlua='z.lua'
	if ! empty($ZLUA_SCRIPT)
		let zlua=$ZLUA_SCRIPT
	endif
	let dir=system([zlua, '-e', a:pattern])
	if strlen(dir) == 0
		echoerr 'z.lua: directory not found'
		return
	endif
	if &ft ==# 'netrw'
		execute 'Explore '.dir
	elseif &buftype ==# '' && bufname() ==# ''
		" (probably) a new window
		execute 'tcd ' . dir
	else
		wincmd n
		execute 'tcd ' . dir
	endif
endfun

fu user#zlua#comp(ArgLead, CmdLine, CursorPos) abort
	let zlua='z.lua'
	if ! empty($ZLUA_SCRIPT)
		let zlua=$ZLUA_SCRIPT
	endif

	return systemlist([zlua, '--complete', a:ArgLead])
endfun

