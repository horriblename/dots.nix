" from: https://gist.github.com/romainl/eae0a260ab9c135390c30cd370c20cd7
" CHANGELOG
" - separate command ':RedirBar'
" - use ':botright new' instead of ':vnew' for full width window at bottom
" - use :term for !-commands
function! Redir(cmd, rng, start, end)
	for win in range(1, winnr('$'))
		if getwinvar(win, 'scratch')
			execute win . 'windo close'
		endif
	endfor
	if a:cmd =~ '^!'
		let cmd = a:cmd =~' %'
			\ ? matchstr(substitute(a:cmd, ' %', ' ' . shellescape(escape(expand('%:p'), '\')), ''), '^!\zs.*')
			\ : matchstr(a:cmd, '^!\zs.*')
      botright new
      execute "term " .. cmd
      "if &lines > line('$')
      "   let &lines=line('$')
      "endif
      resize
      0file!
      return
	else
		redir => output
		execute a:cmd
		redir END
		let output = split(output,"\n")
	endif
   
	botright new
	let w:scratch = 1
	setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile
	call setline(1, output)
endfunction

" This command definition includes -bar, so that it is possible to "chain" Vim commands.
" Side effect: double quotes can't be used in external commands
command! -nargs=1 -complete=command -bar -range ReBar silent call Redir(<q-args>, <range>, <line1>, <line2>)

" This command definition doesn't include -bar, so that it is possible to use double quotes in external commands.
" Side effect: Vim commands can't be "chained".
command! -nargs=1 -complete=command -range Re silent call Redir(<q-args>, <range>, <line1>, <line2>)

" nnoremap : :Re 
