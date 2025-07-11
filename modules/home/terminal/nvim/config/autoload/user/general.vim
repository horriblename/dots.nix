" vim: foldmethod=marker
" Putting this in autoload to allow for more fine-grained control over execution sequence,
" This is especially useful for sourcing these configs before lunarvim
" To 'source' this config:
"   :call user#general#setup()

" Putting this in autoload has the side effect of avoiding overwriting lunarvim's configs
" on reload, since this file will only be sourced once

" dummy function
fu user#general#setup() abort
endfu

" General Options
" {{{
set mouse=a
set mousemodel=extend
set ignorecase
set smartcase
set wildignorecase
set incsearch
set encoding=utf-8
set autoindent
set linebreak
set spelllang=en,de
set foldlevel=99
set undofile
set autowrite
set conceallevel=2
set cedit=\<C-q>
set jumpoptions=stack
set formatoptions+=ro/
set timeoutlen=400
let &isfname = '@,48-57,/,\,.,-,_,+,,,#,$,%,~,='
set completeopt=menu,popup,noinsert,fuzzy,menuone

" Tab Settings
set noexpandtab
set tabstop=4
set shiftwidth=0   " 0 = follow tabstop
"set softtabstop=3

" Appearance
set number relativenumber
set termguicolors
set scrolloff=5
set nowrap
set sidescroll=5
set sidescrolloff=2
set cursorline
set lazyredraw
set cmdheight=1
set noshowmode
set splitbelow splitright
set colorcolumn=+1
set matchpairs+=<:>,*:*,`:`
set list listchars=tab:\ \ ,trail:·
set fillchars=diff:╱,foldopen:▼,foldclose:⯈

fu g:Listchars(expandtab, tabstop)
	let head = get(b:, 'enable_indent_hints', 1) ? '│' : ' '

	let tail_space = a:expandtab ? ' ' : '·'
	let tail_tab   = a:expandtab ? '→' : ' '
	let body_space = repeat(tail_space, a:tabstop - 2)
	return printf('trail:·,tab:%s %s,leadmultispace:%s%s%s', head, tail_tab, head, body_space, tail_space)
endfu

augroup SetListChars
	au!
	au OptionSet expandtab let &l:listchars = g:Listchars(v:option_new, shiftwidth())
	au OptionSet shiftwidth,tabstop let &l:listchars = g:Listchars(&l:expandtab, shiftwidth())
	" reset listchars after modeline/.editorconfig settings
	au BufWinEnter * let &l:listchars = g:Listchars(&l:expandtab, shiftwidth())
augroup END

command -bar IndentHintsToggle let b:enable_indent_hints = !get(b:, 'enable_indent_hints', v:true) | let &l:listchars = g:Listchars(&l:expandtab, shiftwidth())

fu user#general#foldtext()
	let text = getline(v:foldstart)->substitute('\t', repeat(' ', &tabstop), 'g')
    return text . '  󰁂 ' . (v:foldend - v:foldstart + 1) . ' lines'
endfu
set foldtext=user#general#foldtext()

set wildcharm=<Tab>
set wildmode=longest:full
set wildoptions=fuzzy,pum
set wildmenu

set cmdwinheight=4

set path-=/usr/include
set path+=**
set clipboard=

" vim 'exrc' is not very secure
if has('nvim')
	set exrc
endif

" User Commands
" {{{
command! -bar -nargs=1 -complete=customlist,user#zlua#comp Z call user#zlua#chdir(<q-args>)
command! -bar -nargs=1 -complete=customlist,user#ansicolors#AnsiColorComp AnsiColor call user#ansicolors#InsertAnsiTermColor(<q-args>)

" Save file as sudo when no sudo permissions
if has('vim')
	command! Sudowrite write !sudo tee % <bar> edit!
else " nvim
	command! Sudowrite call s:nvimSudoWrite()
endif
" CDC = Change to Directory of Current file
command! CDC cd %:p:h
" delete augroup
command! -nargs=1 -complete=augroup AugroupDel call user#general#AugroupDel(<q-args>)
command! -nargs=1 -complete=file ShareVia0x0 
			\ call setreg(v:register, system('curl --silent -F"file=@"'.expand(<q-args>).' https://0x0.st')) <bar>
			\ echo getreg()

" }}}

" Autocmds
" {{{
if has('nvim') && (!has('lua') || luaeval('not lvim'))
	augroup TerminalTweaks
		au!
		au TermOpen * setlocal nolist nonumber norelativenumber statusline=%{b:term_title}
		au TermOpen * let b:term_title=substitute(get(b:, 'term_title', ''),'.*:','',1) | startinsert
		au BufEnter,BufWinEnter,WinEnter term://* if nvim_win_get_cursor(0)[0] > line('$') - nvim_win_get_height(0) | startinsert | endif
	augroup END

	augroup YankHighlight
		au!
		au TextYankPost * silent! lua vim.highlight.on_yank()
	augroup END
endif

" default behavior: closing tab opens the next one, I want the previous one
" instead
augroup FixTabClose
	au!
	au TabClosed * if str2nr(expand('<afile>')) <= tabpagenr('$') | tabprev | endif
augroup END

augroup DotsColorTweaks
	au!
	au ColorScheme night-owl hi NonText gui=nocombine
	au ColorScheme night-owl hi DiffAdd guifg=NONE guibg=#2e3b1f
	au ColorScheme night-owl hi DiffDelete guifg=NONE guibg=#5a2625
	au ColorScheme night-owl hi DiffChange guifg=NONE gui=NONE guibg=#4a3e1a
	au ColorScheme night-owl hi DiffText guifg=NONE guibg=#7d6213
augroup END
" }}}

let g:markdown_folding = 1

" function definitions {{{
fu s:nvimSudoWrite() abort
	redir => output
	silent write !sudo -n tee % > /dev/null
	redir END

	if empty(output)
		edit!
		return
	elseif output->split('\n')->match('sudo: a password is required') == -1
		echo output
		echo 'write this to a temp file and move it here if you still want to proceed'
		return
	endif

	let password = inputsecret('sudo password: ')
	exec printf('write !cat <(echo %s) - | sudo -S tee %s > /dev/null', shellescape(password), expand('%:p'))

	edit!
	" if we pass the password into `sudo -S tee %` when no password is
	" required, the password will be written to the first line, this is more of
	" a last resort in case some thing went wrong
	call assert_true(password != getline('1'), 'something went wrong: delete the first line of your file and perhaps delete the undofile !')
endfu

fu user#general#GotoNextFloat(reverse) abort
	if !has("nvim")
		return
	endif
	let loop_from = 1
	let curr_c = nvim_win_get_config(0)
	if !empty(curr_c.relative)
		let loop_from = winnr() + 1
	endif

	let loop = range(loop_from, winnr('$'))
	if loop_from != 1
		let loop += range(1, loop_from-2)
	endif
	if a:reverse
		let loop = reverse(loop)
	endif

	for w in loop
		let c = nvim_win_get_config(win_getid(w))
		if c.focusable && !empty(c.relative)
			execute w . 'wincmd w'
			execute 'echo w'
			break
		endif
	endfor
endfunction

fu user#general#AugroupDel(group) abort
	exec 'augroup '.a:group.' | au! | augroup END | augroup! '.a:group
endfu

if has('nvim')
	fu user#general#ToggleTerm() abort
		let buf=bufnr('^term://*#toggleterm#')
		" buffer doesn't exist
		if buf == -1
			let h=min([&lines/2, 15])
			exec 'botright ' . h .'new'
			" this probably won't work with non posix-like shells
			exec 'e term://' . &shell . ';\#toggleterm\#'
			return
		endif

		let win=bufwinnr(buf)

		" window exists
		if win != -1
			exec 'close ' . win
			return
		endif

		" buf exists but window does not
		let h=min([&lines/2, 15])
		exec 'botright ' . h .'new'
		exec 'buf ' . buf
	endfu
else " TODO vim version
	fu user#general#ToggleTerm() abort
		term
	endfu
endif

fu user#general#getVisualSelection() abort
	let [line_start, column_start] = getpos("'<")[1:2]
	let [line_end, column_end] = getpos("'>")[1:2]
	let lines = getline(line_start, line_end)
	if len(lines) == 0
		return ''
	endif
	let lines[-1] = lines[-1][: column_end - (&selection == 'inclusive' ? 1 : 2)]
	let lines[0] = lines[0][column_start - 1:]
	return join(lines, "\n")
endfu
" }}}
