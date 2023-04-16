setlocal foldmethod=expr foldlevel=0
setlocal foldexpr=len(split(trim(getline(v:lnum),'/',2),'/',1))-1
setlocal foldtext='\ ╰...'
