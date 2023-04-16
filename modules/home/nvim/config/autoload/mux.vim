let s:mux_zsh="autoload/mux/.zshrc"

fu! mux#setup()
	set laststatus=2 cmdheight=1 nohidden

	map	<leader>q :close<CR>

	map	<C-S-T> :tabnew +term<CR>
	map!	<C-S-T> <Esc>:tabnew +term<CR>
	tmap	<C-S-T> <C-\><C-N>:tabnew +term<CR>
	map	<C-S-W> :tabclose<CR>
	map!	<C-S-W> <Esc>:tabclose<CR>
	tmap	<C-S-W> <C-\><C-N>:tabclose<CR>

	map	<C-S-l> :+tabmove<CR>
	map!	<C-S-l> <Esc>:+tabmove<CR>
	tmap	<C-S-l> <C-\><C-N>:+tabmove<CR>
	map	<C-S-h> :-tabmove<CR>
	map!	<C-S-h> <Esc>:-tabmove<CR>
	tmap	<C-S-h> <C-\><C-N>:-tabmove<CR>

	map	<C-S-9> :vnew +term<CR>
	map!	<C-S-9> <Esc>:vnew +term<CR>
	tmap	<C-S-9> <C-\><C-N>:vnew +term<CR>
	map	<C-S-0> :new +term<CR>
	map!	<C-S-0> <Esc>:new +term<CR>
	tmap	<C-S-0> <C-\><C-N>:new +term<CR>

	tmap	<C-S-V> <C-\><C-N>pi
	xmap	<C-S-C> y

	augroup MuxTerminal
		au!
		au TermOpen * setlocal hidden
	augroup END

	set tabline=%!v:lua.require'mux.tabline'.tabline()

	if file_readable(stdpath('state').'/mux_start.vim')
		exec 'so '.stdpath('state').'/mux_start.vim'
	else
		term
	endif
endfu
