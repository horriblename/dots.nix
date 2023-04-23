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
	au ColorScheme gruvbox hi Comment guifg=#a5998d | hi Visual gui=NONE
	au ColorScheme * hi Normal guibg=NONE
augroup END

" habamax colorscheme is available since vim 9.0.133 or nvim 0.8.3 (or earlier idk)
silent! colorscheme habamax
