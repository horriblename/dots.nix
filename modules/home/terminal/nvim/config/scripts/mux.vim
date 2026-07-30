let SessionLoad = 1
let s:so_save = &g:so | let s:siso_save = &g:siso | setg so=0 siso=0 | setl so=-1 siso=-1
let v:this_session=expand("<sfile>:p")
doautoall SessionLoadPre
hi Normal guibg=NONE
hi NormalNC guibg=NONE
hi SignColumn guibg=NONE
silent only
silent tabonly
cd ~
if expand('%') == '' && !&modified && line('$') <= 1 && getline(1) == ''
  let s:wipebuf = bufnr('%')
endif
badd term://~//2846:/run/current-system/sw/bin/zsh
badd +10 Documents/TODO.md
argglobal
%argdel
edit Documents/TODO.md
wincmd _ | wincmd |
vsplit
1wincmd h
wincmd w
wincmd t
set winheight=1
set winwidth=1
exe 'vert 1resize ' . ((&columns * 92 + 93) / 186)
exe 'vert 2resize ' . ((&columns * 93 + 93) / 186)
tcd ~/Documents
argglobal
if bufexists(fnamemodify("term://~//2846:/run/current-system/sw/bin/zsh", ":p")) | buffer term://~//2846:/run/current-system/sw/bin/zsh | else | edit term://~//2846:/run/current-system/sw/bin/zsh | endif
if &buftype ==# 'terminal'
  silent file term://~//2846:/run/current-system/sw/bin/zsh
endif
balt ~/Documents/TODO.md
let s:l = 9 - ((8 * winheight(0) + 25) / 51)
if s:l < 1 | let s:l = 1 | endif
keepjumps exe s:l
normal! zt
keepjumps 9
normal! 02|
lcd ~
wincmd w
argglobal
balt term://~//2846:/run/current-system/sw/bin/zsh
7
sil! normal! zo
18
sil! normal! zo
let s:l = 21 - ((20 * winheight(0) + 25) / 51)
if s:l < 1 | let s:l = 1 | endif
keepjumps exe s:l
normal! zt
keepjumps 21
normal! 03|
lcd ~/Documents
wincmd w
tabnext 1
if exists('s:wipebuf') && len(win_findbuf(s:wipebuf)) == 0 && getbufvar(s:wipebuf, '&buftype') isnot# 'terminal'
  silent exe 'bwipe ' . s:wipebuf
endif
unlet! s:wipebuf
set winheight=1 winwidth=20
let s:sx = expand("<sfile>:p:r")."x.vim"
if filereadable(s:sx)
  exe "source " . fnameescape(s:sx)
endif
let &g:so = s:so_save | let &g:siso = s:siso_save
doautoall SessionLoadPost
unlet SessionLoad
" vim: set ft=vim :
