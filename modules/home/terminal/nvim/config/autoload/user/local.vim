if luaeval('not lvim') && !get(g:, 'nvide', 0) && !get(g:, 'neovide', 0)
	augroup TransparentBackground
		au!
		au  ColorScheme * if get(g:, "transparent_bg", 1) | hi Normal guibg=NONE | endif
	augroup END
endif

fu user#local#setup() abort
endfu
