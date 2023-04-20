" Keymaps {{{
let mapleader = " "

" Editor mappings {{{
xnoremap > >gv
xnoremap < <gv

noremap <leader>/ :ToggleLineComments<cr>

vnoremap <Tab>    >gv
vnoremap <S-Tab>  <gv

noremap! <C-BS> <C-w>

tnoremap <M-C-N> <C-\><C-n>
tnoremap <M-C-V> <cmd>put "<CR>

noremap gh ^
noremap gl g_
noremap gL g$
noremap gH g^

noremap! <C-h> <Left>
noremap! <C-l> <Right>
inoremap <C-k> <Up>
inoremap <C-j> <Down>

inoremap <C-r><C-k> <C-k>

nnoremap gV ^v$
xnoremap ga gg0oG$

xnoremap X "_x
vnoremap <C-n> :m '>+1<CR>gv-gv
vnoremap <C-p> :m '<-2<CR>gv-gv

" Autoclose
inoremap <expr> " user#autoclose#InsertSymmetric('"')
inoremap <expr> ' user#autoclose#InsertSymmetric("'")
inoremap <expr> ` user#autoclose#InsertSymmetric('`')
inoremap ( ()<left>
inoremap [ []<left>
inoremap { {}<left>
inoremap {<CR> {<CR>}<ESC>O
inoremap <expr> ) user#autoclose#CloseRight(")")
inoremap <expr> ] user#autoclose#CloseRight("]")
inoremap <expr> } user#autoclose#CloseRight("}")

nnoremap S :%s##gI<Left><Left><Left>
xnoremap S :s##gI<Left><Left><Left>

" surround with parenthesis. Using register "z to not interfere with clipboard
xmap s <Nop>
xnoremap s( "zs()<Esc>"zPgvlOlO<Esc>
xnoremap s) "zs()<Esc>"zPgvlOlO<Esc>
xnoremap sb "zs()<Esc>"zPgvlOlO<Esc>
xnoremap s[ "zs[]<Esc>"zPgvlOlO<Esc>
xnoremap s] "zs[]<Esc>"zPgvlOlO<Esc>
xnoremap s{ "zs{}<Esc>"zPgvlOlO<Esc>
xnoremap s} "zs{}<Esc>"zPgvlOlO<Esc>
xnoremap sB "zs{}<Esc>"zPgvlOlO<Esc>
xnoremap s< "zs<><Esc>"zPgvlOlO<Esc>
xnoremap s> "zs<><Esc>"zPgvlOlO<Esc>
xnoremap s" "zs""<Esc>"zPgvlOlO<Esc>
xnoremap s' "zs''<Esc>"zPgvlOlO<Esc>
xnoremap s` "zs``<Esc>"zPgvlOlO<Esc>
xnoremap s* "zs**<Esc>"zPgvlOlO<Esc>
xnoremap s_ "zs__<Esc>"zPgvlOlO<Esc>
xnoremap se "zs****<Left><Esc>"zPgvllOllO<Esc>
xnoremap sE "zs******<Left><Left><Esc>"zPgv3lO3lO<Esc>
xnoremap s<space> "zs<space><space><Esc>"zPgvlOlO<Esc>
" single line only, `gv` highlights whole thing including surrounding tag
xnoremap su "zy:let @z='<u>'..@z..'</u>'<cr>gv"zP

" de-surround
for char in "(){}[]<>bBt"
	exec 'nnoremap ds'.char ' di'.char.'va'.char.'pgv'
endfor

" quotes are single-line only, so this can work
" using a different keymap as `da'` could delete a whitespace
for char in "\"`'"
	exec 'nnoremap' 'ds'.char ' di'.char.'vhpgv'
endfor

" keyboard layout switching
"nnoremap <leader>y :set langmap=yYzZ\\"§&/()=?`ü+öä#-Ü*ÖÄ'\\;:_;zZyY@#^&*()_+[]\\;'\\\\/{}:\\"\\|\\<\\>?<cr>
"nnoremap <leader>z :set langmap=<cr>

" quick settings
nnoremap <leader>zn :set number! relativenumber!<cr>
nnoremap <leader>z<Tab> :set expandtab! <bar> set expandtab?<cr>
nnoremap <leader>zw :set wrap! <bar> set wrap?<CR>
" set transparency - I usually have an autocmd on ColorScheme events to set
" transparent background, :noau ignores the autocmd (and any other aucmd)
nnoremap <leader>zb :set bg=dark<CR>
nnoremap <leader>zB :noau set bg=dark<CR>

silent! nnoremap <unique> <leader>e :25Lexplore<CR>
silent! nnoremap <unique> <leader>f :find 

" quickfix
nnoremap <C-'><C-n> :cnext<CR>
nnoremap <C-'><C-p> :cprev<CR>
nnoremap <C-'><C-'> :copen<CR>

" toggleterm
noremap <M-x> :call ToggleTerm()<cr>
inoremap <M-x> <Esc>:call ToggleTerm()<cr>
tnoremap <M-x> <Cmd>:call ToggleTerm()<cr>
" }}}
" Cmdline/HUD
" {{{
" Cursor movement
noremap! <M-b> <S-Left>
noremap! <M-f> <S-Right>

cnoremap <C-a> <Home>
cnoremap <C-e> <End>
cnoremap <C-d> <Del>

" regex shortcuts
cnoremap <M-w> \<\><Left><Left>
cnoremap <M-g> \(\)<Left><Left>
" }}}
" Window Management {{{
nnoremap <leader>q :q<CR>
nnoremap <leader>Q :q!
nnoremap <leader>c :bdelete<CR>
nnoremap <leader>C :bdelete!<CR>
nnoremap <M-c> :bdelete<CR>
inoremap <M-c> <Esc>:bdelete<CR>
nnoremap <M-c> <C-\><C-N>:bdelete<CR>
nnoremap <C-s> :w<CR>
nnoremap g<C-s> :noau w<CR>

nnoremap <M-C-.>  <C-W>3>
nnoremap <M-C-,>  <C-W>3<
nnoremap <M-C-=>  <C-W>3+
nnoremap <M-C-->  <C-W>3-
inoremap <M-C-.>  <Esc><C-W>>3i
inoremap <M-C-,>  <Esc><C-W><3i
inoremap <M-C-=>  <Cmd>resize 3+<CR>
inoremap <M-C-->  <Cmd>resize 3-<CR>
tnoremap <M-C-.>  <C-\><C-n><C-W>3>
tnoremap <M-C-,>  <C-\><C-n><C-W>3<
tnoremap <M-C-=>  <C-\><C-n><C-W>3+
tnoremap <M-C-->  <C-\><C-n><C-W>3-

nnoremap <leader>r :n#<CR>

nnoremap <C-/> :nohlsearch<cr>
nnoremap <C-_> :nohlsearch<cr>

tnoremap <A-h> <C-\><C-N><C-w>h
tnoremap <A-j> <C-\><C-N><C-w>j
tnoremap <A-k> <C-\><C-N><C-w>k
tnoremap <A-l> <C-\><C-N><C-w>l
inoremap <A-h> <C-\><C-N><C-w>h
inoremap <A-j> <C-\><C-N><C-w>j
inoremap <A-k> <C-\><C-N><C-w>k
inoremap <A-l> <C-\><C-N><C-w>l
nnoremap <A-h> <C-w>h
nnoremap <A-j> <C-w>j
nnoremap <A-k> <C-w>k
nnoremap <A-l> <C-w>l

nnoremap <M-n>      :bnext<CR>
nnoremap <M-p>      :bNext<CR>
inoremap <M-n>      <Esc>:bnext<CR>
inoremap <M-p>      <Esc>:bNext<CR>
tnoremap <M-n>      <C-\><C-n>:bnext<CR>
tnoremap <M-p>      <C-\><C-n>:bNext<CR>

nnoremap <leader>t  :tabnew<CR>
nnoremap <M-.>		  :tabnext<CR>
nnoremap <M-,>      :tabprevious<CR>
nnoremap <C-Tab>    :tabnext<CR>
nnoremap <C-S-Tab>  :tabprevious<CR>
inoremap <C-Tab>    <Esc>:tabnext<CR>
inoremap <C-S-Tab>  <Esc>:tabprevious<CR>
inoremap <M-.>      <Esc>:tabnext<CR>
inoremap <M-,>      <Esc>:tabprevious<CR>
tnoremap <C-Tab>    <C-\><C-n>:tabnext<CR>
tnoremap <C-S-Tab>  <C-\><C-n>:tabprevious<CR>
tnoremap <M-.>      <C-\><C-n>:tabnext<CR>
tnoremap <M-,>      <C-\><C-n>:tabprevious<CR>

for i in range(1,8)
	exec 'nnoremap <M-' . i . '> :' . i . 'tabnext<CR>'
	exec 'inoremap <M-' . i . '> <Esc>:' . i . 'tabnext<CR>'
	exec 'tnoremap <M-' . i . '> <C-\><C-n>:' . i . 'tabnext<CR>'
endfor
noremap <M-9> :$tabnext<CR>

noremap <M-i> :<c-u>call GotoNextFloat(1)<cr>
noremap <M-o> :<c-u>call GotoNextFloat(0)<cr>

" }}}

" Abbreviations {{{
noreab term_red    \x1b[31m
noreab term_green  \x1b[32m
noreab term_orange \x1b[33m
noreab term_blue   \x1b[34m
noreab term_mag    \x1b[35m
noreab term_aqua   \x1b[26m
noreab term_grey   \x1b[27m
noreab term_reset  \x1b[0m
" }}}

" Plugins
nnoremap <silent> <leader>u :UndotreeToggle <bar> UndotreeFocus<CR>
" }}}

" function definitions {{{
fu! s:nvimSudoWrite()
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

" focus the first floating window found
fu! GotoFirstFloat() abort
  for w in range(1, winnr('$'))
	 let c = nvim_win_get_config(win_getid(w))
	 if c.focusable && !empty(c.relative)
		execute w . 'wincmd w'
	 endif
  endfor
endfu

fu! GotoNextFloat(reverse) abort
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

fu! s:getIndentOfLength(length)
	if &expandtab
		return repeat(' ', a:length)
	endif

	let tabs = a:length / &tabstop
	return repeat("\t", tabs)
endfu

fu! ToggleLineComment(lnum, indent)
	let comm=&commentstring
	if comm->strpart(0, 2) == '%s' || empty(comm)
		echoerr "commentstring does not have preceding symbol or is empty"
	endif

	let exprs = comm->split("%s")

	let beg_str = exprs[0]
	let end_str = exprs->get(1, "") 
	let beg_re = '\(' . beg_str->trim() . ' \?\)\?'
	let end_re = '\(' . end_str->trim() . '\)\?'
	if a:indent < 0
		let a:indent = indent(a:lnum)
	endif

	let tabs = a:indent / &tabstop
	let indent_re = escape('^((\t| {'.&tabstop.'}){'.tabs.'})', '(){}|')

	let mlist = matchlist(getline(a:lnum), indent_re. beg_re . '\(.*\)' . end_re . '$')

	if len(mlist) == 0
		echo "error matching line " . a:lnum . "with indents " . a:indent
		return
	endif

	let extra_groups = len(mlist) - 10

	let [_, indents, _, cmatch_beg; rest] = mlist 
	let code = rest[0 + extra_groups]
	let trail = rest[2 + extra_groups]

	if !empty(cmatch_beg)
		call setline(a:lnum, indents . code . trail)
	else
		call setline(a:lnum, indents . beg_str . code . end_str . trail)
	endif
endfu

fu! ToggleLineCommentOnRange(line1, line2)
	let min_ind = indent(a:line1)
	for lnum in range(a:line1, a:line2)
		let min_ind = min([min_ind, indent(lnum)])
	endfor

	for lnum in range(a:line1, a:line2)
		call ToggleLineComment(lnum, min_ind)
	endfor
endfu

fu! AugroupDel(group)
	exec 'augroup '.a:group.' | au! | augroup END | augroup! '.a:group
endfu

fu! Zlua(pattern)
	let zlua='z.lua'
	if ! empty($ZLUA_SCRIPT)
		let zlua=$ZLUA_SCRIPT
	endif
	let dir=system([zlua, '-e', a:pattern])
	if strlen(dir) == 0
		echoerr 'z.lua: directory not found'
		return
	endif
	if &ft == "netrw"
		execute "Explore ".dir
	else
		execute "cd ".dir
	endif
endfun

fu! ZluaComp(ArgLead, CmdLine, CursorPos)
	let zlua='z.lua'
	if ! empty($ZLUA_SCRIPT)
		let zlua=$ZLUA_SCRIPT
	endif

	return systemlist([zlua, '--complete', a:ArgLead])
endfun

if has('nvim')
	fu! ToggleTerm()
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
	fu! ToggleTerm()
		term
	endfu
endif
" }}}
" General Options
" {{{
set mouse=a
set mousemodel=extend
syntax on
set ignorecase
set smartcase
set incsearch
set encoding=utf-8
set autoindent
set linebreak
set spelllang=en,de

" Tab Settings
set noexpandtab
set tabstop=3
set shiftwidth=0   " 0 = follow tabstop
"set softtabstop=3

" Appearance
set number relativenumber
set termguicolors
set scrolloff=5
set cursorline
set lazyredraw
set cmdheight=1
set noshowmode
set splitbelow splitright
set matchpairs+=<:>,*:*,`:`
set list listchars=tab:\ \ ,trail:·
set fillchars+=diff:╱

augroup SetListChars
	au!
	au OptionSet expandtab if &expandtab | setl listchars=tab:\ \ →,trail:· | else | set listchars=tab:\ \ ,lead:·,trail:· | endif
	au BufNew * if &expandtab | setl listchars=tab:\ \ →,trail:· | else | set listchars=tab:\ \ ,lead:·,trail:· | endif
augroup END

set wildcharm=<Tab>
set wildmode=longest:full
set wildmenu

set cmdwinheight=4

set path-=/usr/include
set path+=**
" Use system clipboard, change to unnamed for vim
if has('nvim')
	set clipboard=unnamedplus
else
	set clipboard=unnamed
endif
" }}}

command! -bar -nargs=1 -complete=customlist,ZluaComp Z call Zlua(<q-args>)

" Save file as sudo when no sudo permissions
if has('vim')
	command! Sudowrite write !sudo tee % <bar> edit!
else " nvim
	command! Sudowrite call s:nvimSudoWrite()
endif
" CDC = Change to Directory of Current file
command! CDC cd %:p:h
" delete augroup
command! -nargs=1 AugroupDel call AugroupDel(<q-args>)
command! -addr=lines ToggleLineComments call ToggleLineCommentOnRange(<line1>, <line2>)
command! -nargs=1 -complete=file ShareVia0x0 
			\ call setreg(v:register, system('curl --silent -F"file=@"'.expand(<q-args>).' https://0x0.st')) <bar>
			\ echo getreg()

if has('nvim') && (!has('lua') || luaeval('not lvim'))
	augroup TerminalTweaks
		au!
		au TermOpen * setlocal nolist nonumber norelativenumber statusline=%{b:term_title}
		au TermOpen * let b:term_title=substitute(b:term_title,'.*:','',1) | startinsert
		au BufEnter,BufWinEnter,WinEnter term://* if nvim_win_get_cursor(0)[0] > line('$') - nvim_win_get_height(0) | startinsert | endif
	augroup END

	au TextYankPost * silent! lua vim.highlight.on_yank()
	lua vim.unload_module = function (mod) package.loaded[mod] = nil end
endif

" auto load ft plugins (vim compatibility) 
filetype plugin on

let g:markdown_folding = 1
