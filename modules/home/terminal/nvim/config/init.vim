call user#mapping#setup()
call user#general#setup()
" may not exist
silent! call user#local#setup()

if !empty($NVIM)
	call mux#subshell#setup()
endif

augroup ColorTweaks
	au!
	au ColorScheme badwolf hi Comment guifg=#aaa6a1
	au ColorScheme slate hi Comment guifg=#a5998d | hi Visual gui=NONE
	au ColorScheme slate hi clear MatchParen
	au ColorScheme slate hi MatchParen guifg=orange
	au ColorScheme slate hi WinSeparator guibg=bg guifg=smokewhite
	au ColorScheme * hi Normal guibg=NONE
	au ColorScheme * hi Cursor gui=NONE guibg=white guifg=black
augroup END
