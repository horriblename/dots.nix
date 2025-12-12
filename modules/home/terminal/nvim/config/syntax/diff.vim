" Vim syntax file for highlighting git --word-diff markers.
" Highlights:
"   [-deleted-]   → deleted text highlighted, markers concealed
"   {+added+}     → added text highlighted, markers concealed

" Enable conceal
setlocal conceallevel=2
setlocal concealcursor=nvic

" -----------------------------
" Syntax groups
" -----------------------------

syntax region gitWordDiffDelete matchgroup=gitWordDiffDelMarker 
			\ start="\[-" end="-\]" contains=gitWordDiffDeleteInner concealends

syntax region gitWordDiffAdd matchgroup=gitWordDiffAddMarker 
			\ start="{+" end="+}" contains=gitWordDiffAddInner concealends

" Inner text inside the markers
syntax match gitWordDiffDeleteInner "\%(\[-\)\@<=.\{-}\%(-\]\)\@=" contained
syntax match gitWordDiffAddInner    "\%({+\)\@<=.\{-}\%(+}\)\@=" contained

" -----------------------------
" Highlighting
" -----------------------------

" Markers are concealed, but we define them anyway
highlight default link gitWordDiffDelMarker Comment
highlight default link gitWordDiffAddMarker Comment

" Main colors
highlight default link gitWordDiffDeleteInner DiffDelete
highlight default link gitWordDiffAddInner    DiffAdd
