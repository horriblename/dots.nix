" vim: foldmethod=marker
fu! user#mapping#setup()
	" dummy function
endfu

let mapleader=" "

" call this function directly to re-setup
fu! user#mapping#resetup()
	" Editor mappings {{{
	nnoremap > >>
	nnoremap < <<
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

	" \x16 is <c-v>
	xnoremap <expr> I mode() ==# "\x16"? "I" : "\<Esc>`<i"
	xnoremap <expr> A mode() ==# "\x16"? "A" : "\<Esc>`>a"

	xnoremap X "_x
	vnoremap <C-n> :m '>+1<CR>gv-gv
	vnoremap <C-p> :m '<-2<CR>gv-gv

	" Autoclose
	inoremap <expr> " user#autoclose#InsertSymmetric('"')
	"inoremap <expr> ' user#autoclose#InsertSymmetric("'")
	inoremap <expr> ` user#autoclose#InsertSymmetric('`')
	inoremap ( ()<left>
	inoremap [ []<left>
	inoremap { {}<left>
	inoremap {<CR> {<CR>}<ESC>O
	inoremap <expr> ) user#autoclose#CloseRight(")")
	inoremap <expr> ] user#autoclose#(CloseRight)("]")
	inoremap <expr> } user#(autoclose)#CloseRight("}")

	nnoremap S :%s##gI<Left><Left><Left>
	xnoremap S :s##gI<Left><Left><Left>

	fu s:surround(left, right)
		if mode() ==# "V"
			return '"zs' . a:left . "\<cr>" . a:right . "\<Esc>\"zgPm>"
		else
			let offset_left = "h"->repeat(len(a:right) - 1)
			let offset_right = "l"->repeat(len(a:right) - 1)
			return '"zs' . a:left . a:right . "\<Esc>" . offset_left . "\"zgP" . offset_right . "m>"
		endif
		return
	endfu

	fu s:surroundTag()
		let name = input('Surround with tag: ')
		return s:surround('<'.name.'>', '<'.name.'/>')
	endfu

	xmap s <Nop>
	xnoremap <expr> s( <SID>surround('(', ')')
	xnoremap <expr> s) <SID>surround('(', ')')
	xnoremap <expr> sb <SID>surround('(', ')')
	xnoremap <expr> s[ <SID>surround('[', ']')
	xnoremap <expr> s] <SID>surround('[', ']')
	xnoremap <expr> s{ <SID>surround('{', '}')
	xnoremap <expr> s} <SID>surround('{', '}')
	xnoremap <expr> sB <SID>surround('{', '}')
	xnoremap <expr> s< <SID>surround('<', '>')
	xnoremap <expr> s> <SID>surround('<', '>')
	xnoremap <expr> s" <SID>surround('"', '"')
	xnoremap <expr> s' <SID>surround("'", "'")
	xnoremap <expr> s` <SID>surround('`', '`')
	xnoremap <expr> s* <SID>surround('*', '*')
	xnoremap <expr> s_ <SID>surround('_', '_')
	xnoremap <expr> se <SID>surround('**', '**')
	xnoremap <expr> sE <SID>surround('***', '***')
	xnoremap <expr> s<space> <SID>surround(' ', ' ')
	" single line only, `gv` highlights whole thing including surrounding tag
	xnoremap <expr> su <SID>surround('<u>', '</u>')
	xnoremap <expr> st <SID>surroundTag()

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
	nnoremap <leader>zl :set langmap=yYzZ\\"§&/()=?`ü+öä#-Ü*ÖÄ'\\;:_;zZyY@#^&*()_+[]\\;'\\\\/{}:\\"\\|\\<\\>?<cr>
	nnoremap <leader>zL :set langmap=<cr>

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
	nnoremap '<C-n> :cnext<CR>
	nnoremap '<C-p> :cprev<CR>

	" toggleterm
	noremap <M-x> :call user#general#ToggleTerm()<cr>
	inoremap <M-x> <Esc>:call user#general#ToggleTerm()<cr>
	tnoremap <M-x> <Cmd>call user#general#ToggleTerm()<cr>
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

	" Why is this not builtin??
	cnoremap <expr> <C-r><C-v> user#general#getVisualSelection()->split('\n')->get(0, "")
	cnoremap <expr> <C-r>v user#general#getVisualSelection()->split('\n')->get(0, "")
	" }}}
	" Window Management {{{
	nnoremap <leader>q :q<CR>
	nnoremap <leader>Q :q!
	nnoremap <leader>c :bdelete<CR>
	nnoremap <leader>C :bdelete!<CR>
	nnoremap <C-s> :w<CR>
	nnoremap g<C-s> :noau w<CR>
	nnoremap <c-w>Z :exec 'tabnew +'. line('.') . ' %'<cr>

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
	nnoremap <M-.>      :tabnext<CR>
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
		exec 'noremap <M-' . i . '> :' . i . 'tabnext<CR>'
		exec 'inoremap <M-' . i . '> <Esc>:' . i . 'tabnext<CR>'
		exec 'tnoremap <M-' . i . '> <C-\><C-n>:' . i . 'tabnext<CR>'
	endfor
	noremap <M-9> :$tabnext<CR>

	noremap <M-C-I> :<c-u>call user#general#GotoNextFloat(1)<cr>
	noremap <M-C-O> :<c-u>call user#general#GotoNextFloat(0)<cr>

	" }}}

	" Plugins
	nnoremap <silent> <leader>u :UndotreeToggle <bar> UndotreeFocus<CR>
endfu

call user#mapping#resetup()
