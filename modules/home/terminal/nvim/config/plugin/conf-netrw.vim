" Basic Settings
let g:netrw_banner = 0
let g:netrw_liststyle = 0
let g:netrw_keepdir = 1
let g:netrw_list_hide='^\./,^\.\./'
let g:netrw_sizestyle = 'H'
let g:netrw_browse_split = 0
let g:netrw_alto = 0
let g:netrw_altv = 1
let g:netrw_preview=1
if has('unix')
   let g:netrw_browsex_viewer = 'xdg-open'
endif
let g:Netrw_UserMaps = [
         \['K', 'netrw#custom#MarkFileUp'],
         \['J', 'netrw#custom#MarkFileDown'],
         \['i', 'netrw#custom#ListStyleVerbose'],
         \['s', 'netrw#custom#SortByVerbose'],
			\['a', 'netrw#custom#NewFileOrDir'],
         \['y', 'netrw#custom#SetPasteOpAsCopy'],
         \['x', 'netrw#custom#SetPasteOpAsMove'],
         \['C', 'netrw#custom#ResetPasteOperation'],
         \['p', 'netrw#custom#ClipboardPaste'],
         \['cl', 'netrw#custom#CopyLocation'],
         \['mls', 'netrw#custom#CreateSymLink'],
         \['mlr', 'netrw#custom#CreateRelLink'],
         \['mlh', 'netrw#custom#CreateHardLink'],
         \['P', 'netrw#custom#TogglePreviewMode'],
		\] " relevant functions are decalred below

hi! link netrwMarkFile PmenuSel
hi! netrwCopyMark  guibg=Yellow guifg=black
hi! netrwMoveMark  guibg=Red guifg=black

" defining g:netrw_pasteaction for future use (in ftplugin)
let g:netrw_pasteaction = ''

"  --------------- "
"  For Statusline defined in ftplugin
"  --------------- "
function! NetrwNumOfMarked()
   let marked=netrw#Expose('netrwmarkfilelist')
   if type(marked) != type([]) || len(marked) == 0
      return ''
   endif

   return ' '.len(marked).' '
endfunction
