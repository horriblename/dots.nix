" vim: foldmethod=marker
fu user#mapping#setup() abort
	" dummy function
endfu

let mapleader=' '
let maplocalleader=' a'

" Editor mappings {{{
nnoremap > >>
nnoremap < <<
xnoremap > >gv
xnoremap < <gv

vnoremap <Tab>    >gv
vnoremap <S-Tab>  <gv

inoremap <S-Tab> <C-d>

noremap! <C-BS> <C-w>
tnoremap <C-BS> <C-w>

tnoremap <M-C-V> <cmd>put "<CR>
tnoremap <C-BS> <C-w>

nnoremap <leader>y "+y
nnoremap <leader>Y "+y$
nnoremap <leader>p "+p
nnoremap <leader>P "+P
nnoremap <leader>d "+d
nnoremap <leader>D "+D

xnoremap <leader>y "+y
xnoremap <leader>Y "+y$
xnoremap <leader>p "+p
xnoremap <leader>P "+P
xnoremap <leader>d "+d
xnoremap <leader>D "+D

xnoremap x "_x
nnoremap ' `
nnoremap ` '
xnoremap ' `
xnoremap ` '

nnoremap zV :let &foldlevel = foldlevel('.')<CR>

" Movement {{{

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
onoremap ga :<c-u>normal! ggVG<CR>

nmap <M-o> v<M-o>
xnoremap <M-o> <Plug>(MatchitVisualTextObject)

" \x16 is <c-v>
xnoremap <expr> I mode() ==# "\x16"? "I" : "\<Esc>`<i"
xnoremap <expr> A mode() ==# "\x16"? "A" : "\<Esc>`>a"

vnoremap <C-n> :m '>+1<CR>gv-gv
vnoremap <C-p> :m '<-2<CR>gv-gv

" Indent text object
nnoremap <silent>[i :<C-U>call user#txtobj#FindIndentBegin(0)<CR>
nnoremap <silent>]i :<C-U>call user#txtobj#FindIndentEnd(0)<CR>

onoremap <silent>ai :<C-U>call user#txtobj#IndentTextObj(0)<CR>
onoremap <silent>ii :<C-U>call user#txtobj#IndentTextObj(1)<CR>
vnoremap <silent>ai :<C-U>call user#txtobj#IndentTextObj(0)<CR><Esc>gv
vnoremap <silent>ii :<C-U>call user#txtobj#IndentTextObj(1)<CR><Esc>gv
" }}}

" Autoclose
inoremap <expr> " user#autoclose#InsertSymmetric('"')
"inoremap <expr> ' user#autoclose#InsertSymmetric("'")
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

" surround {{{
fu s:surround(left, right = '')
	let right = a:right ==# '' ? a:left : a:right
	if mode() ==# "V"
		return '"zs' . a:left . "\<cr>" . right . "\<Esc>\"zgPm>"
	else
		let offset_left = "h"->repeat(len(right) - 1)
		let offset_right = "l"->repeat(len(right) - 1)
		return '"zs' . a:left . right . "\<Esc>" . offset_left . "\"zgP" . offset_right . "m>"
	endif
	return
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
xnoremap <expr> sf <SID>surround(getcharstr())

fu s:surroundTag(tag)
	let name = split(a:tag)[0]
	return s:surround('<'.a:tag.'>', '</'.name.'>')
endfu

xnoremap <expr> su <SID>surroundTag('u')
xnoremap <expr> st <SID>surroundTag(input('Surround with tag (and attributes): '))

" }}}
" de-surround
for char in "(){}[]<>bBt"
	exec printf('nnoremap ds%s di%sva%spgv', char, char, char)
	exec printf('nmap <silent><expr> cs%s "di%sva%spgvs" . getcharstr()', char, char, char)
endfor

" quotes are single-line only, so this can work
" using a different keymap as `da'` could delete a whitespace
for char in "\"`'"
	exec printf('nnoremap ds%s di%svhpgv', char, char)
endfor
nmap <silent><expr> cs" printf('di%svhpgvs%s', '"', getcharstr())
nmap <silent><expr> cs' printf('di%svhpgvs%s', "'", getcharstr())
nmap <silent><expr> cs` printf('di%svhpgvs%s', '`', getcharstr())
" desurrounds anything
fu s:desurround_f()
	let c = getcharstr()
	return printf("F%sxm<f%sxm>", c, c)
endfu
nnoremap <expr> dsf <SID>desurround_f()

" keyboard layout switching
nnoremap <leader>zl :set langmap=yYzZ\\"§&/()=?`ü+öä#-Ü*ÖÄ'\\;:_;zZyY@#^&*()_+[]\\;'\\\\/{}:\\"\\|\\<\\>?<cr>
nnoremap <leader>zL :set langmap=<cr>

" quick settings
nnoremap <leader>zn :set number! relativenumber!<cr>
nnoremap <leader>zw :set wrap! <bar> set wrap?<CR>
nnoremap <expr> <leader>z<Tab> set expandtab! <bar> set expandtab?<cr>
nnoremap <expr> <leader>z<Tab> v:count == 0 ? ':set expandtab! \| set expandtab?<cr>' 
			\ : printf(':<C-U>set shiftwidth=%d tabstop=%d<CR>', v:count, v:count)
" set transparency - I usually have an autocmd on ColorScheme events to set
" transparent background, :noau ignores the autocmd (and any other aucmd)
nnoremap <leader>zb :set bg=dark<CR>
nnoremap <leader>zB :noau set bg=dark<CR>
nnoremap <leader>zz :<C-U>let &foldcolumn = v:count == 0 ? 
			\ &foldcolumn ==# "0"? "auto" : "0"
			\ : "auto:" . v:count <CR>
nnoremap <leader>zi :IndentHintsToggle<CR>

" silent! map <unique> prevents new binds from replacing old ones
silent! nnoremap <unique> <leader>e :25Lexplore<CR>
silent! nnoremap <unique> <leader>ff :find 
silent! nnoremap <unique> <leader>fb :buffer 
silent! nnoremap <unique> <leader>f/ :vimgrep // **<Left><Left><Left><Left>

" quickfix
nnoremap <leader>xn :cnext<CR>
nnoremap <leader>xp :cprev<CR>
nnoremap <leader>x, :cnewer<CR>
nnoremap <leader>x; :colder<CR>
nnoremap <leader>xx :botright copen<CR>
nnoremap <leader>xq :cclose<CR>
nnoremap <leader>xc :cclose<CR>

" toggleterm
noremap <M-x> :call user#general#ToggleTerm()<cr>
inoremap <M-x> <Esc>:call user#general#ToggleTerm()<cr>
tnoremap <M-x> <Cmd>close<cr>
" }}}
" {{{ Cmdline/HUD
" Cursor movement
noremap! <C-b> <Left>
noremap! <C-f> <Right>
noremap! <M-b> <S-Left>
noremap! <M-f> <S-Right>

noremap! <C-d> <Del>
cnoremap <expr> <C-a> pumvisible() == 0? '<Home>' : '<C-a>'
cnoremap <C-e> <End>

cnoremap <C-x> <Tab>

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
nnoremap <M-S-c> :edit # <bar> bdelete! #<CR>
nnoremap <C-s> :w<CR>
nnoremap g<C-s> :noau w<CR>
nnoremap <c-w>Z :tabnew<CR><C-o>
function s:closeBuffer()
	return (buflisted(0)? ':edit #' : ':bnext' ) . '| bdelete ' . bufnr() . "\<CR>"
endfu
nnoremap <expr> <M-c> <SID>closeBuffer()

" Resizing
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

" Window Focus
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

" Swap Buffer
nnoremap <M-n>      :bnext<CR>
nnoremap <M-p>      :bNext<CR>
inoremap <M-n>      <Esc>:bnext<CR>
inoremap <M-p>      <Esc>:bNext<CR>
tnoremap <M-n>      <C-\><C-n>:bnext<CR>
tnoremap <M-p>      <C-\><C-n>:bNext<CR>

" Tabs
nnoremap <leader>t  :tabnew<CR>
nnoremap <M-.>      :tabnext<CR>
nnoremap <M-;>      :tabnext<CR>
nnoremap <M-,>      :tabprevious<CR>
nnoremap <C-Tab>    :tabnext<CR>
nnoremap <C-S-Tab>  :tabprevious<CR>
inoremap <C-Tab>    <Esc>:tabnext<CR>
inoremap <C-S-Tab>  <Esc>:tabprevious<CR>
inoremap <M-.>      <Esc>:tabnext<CR>
inoremap <M-;>      <Esc>:tabnext<CR>
inoremap <M-,>      <Esc>:tabprevious<CR>
tnoremap <C-Tab>    <C-\><C-n>:tabnext<CR>
tnoremap <C-S-Tab>  <C-\><C-n>:tabprevious<CR>
tnoremap <M-.>      <C-\><C-n>:tabnext<CR>
tnoremap <M-;>      <C-\><C-n>:tabnext<CR>
tnoremap <M-,>      <C-\><C-n>:tabprevious<CR>

" quickfix
nnoremap <M-'><M-n> :cnext<CR>
nnoremap <M-'><M-p> :cprev<CR>
nnoremap <M-'><M-'> :copen<CR>

" toggleterm
noremap <M-x> :call user#general#ToggleTerm()<cr>
inoremap <M-x> <Esc>:call user#general#ToggleTerm()<cr>
tnoremap <M-x> <Cmd>q<cr>
tnoremap <M-C-N> <C-\><C-n>

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
nnoremap <leader>mt :make test <bar> cwindow<CR>
nnoremap <leader>mr :make run <bar> cwindow<CR>
nnoremap <leader>mb :make build <bar> cwindow<CR>
nnoremap <leader>mc :make clean <bar> cwindow<CR>
nnoremap <leader>mm :make <bar> cwindow<CR>
nnoremap <silent> <leader>u :UndotreeToggle <bar> UndotreeFocus<CR>
