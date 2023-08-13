"  Netrw Function wrappers
"
"  Simply nmapping to netrw#Call('NetrwMarkFile', netrw#Call('NetrwGetWord')
"  doesn't work, likely due to nested netrw#Call, I don't really know
"  TODO consider moving into autoload?
function! s:NetrwMarkFileBinding()
   let l:filespec = netrw#Call('NetrwGetWord')
   silent call netrw#Call('NetrwMarkFile', 1, l:filespec)
endfunction

function! netrw#custom#MarkFileUp( isLocal )
   call s:NetrwMarkFileBinding()
   normal k
   return ""
endfunction

function! netrw#custom#MarkFileDown( isLocal )
   call s:NetrwMarkFileBinding()
   normal j
   return ""
endfunction

" --------------- "
"  tell me what's happening
"  -------------- "
function! netrw#custom#ListStyleVerbose(isLocal)
   if !a:isLocal
      echoerr 'not local session, aborting...'
      return
   endif
   silent call netrw#Call("NetrwListStyle", 1)
   echo get({0: "simple", 1: "info", 2: "compact", 3: "tree"}, w:netrw_liststyle)
   return ""
endfunction

function! netrw#custom#SortByVerbose(isLocal)
   if !a:isLocal
      echoerr 'not local session, aborting...'
      return
   endif
   silent call netrw#Call("NetrwSortStyle", 1)
   echo "sort by: ".g:netrw_sort_by
   return ""
endfunction

" ---------------- "
"  Copy/paste that makes sense
"  --------------- "
function! netrw#custom#ClipboardPaste(isLocal)
   if !a:isLocal
      echoerr 'not local session, aborting...'
      return ""
   endif
   let marked=netrw#Expose("netrwmarkfilelist")
   let dest=getcwd()
   if type(marked) != type([]) " || len(marked) == 0
      echoerr "No files selected"
      return
   endif
   if g:netrw_pasteaction == "copy"
      " hack: on unix uses '-R' option offered by g:netrw_localcopydircmdopt
      " -i on unix 'interactive': ask before overwrite
      let l:baseCmd = g:netrw_localcopycmd." ".g:netrw_localcopydircmdopt
   elseif g:netrw_pasteaction == "move"
      let l:baseCmd = g:netrw_localmovecmd
   else
      echoerr "No paste action selected"
      return ""
   endif

   call netrw#Modify("netrwmarkfilelist", [])
   call netrw#Modify('netrwmarkfilemtch_{bufnr("%")}',"")
   call netrw#custom#ResetPasteOperation(a:isLocal)

   for file in marked
      call system(baseCmd.' "'. file.'" "'.dest.'"')
   endfor

   return ["refresh"]
endfunction

" Set/unset a paste action through g:netrw_pasteaction and select a file under
" the cursor if necessary
function! netrw#custom#ResetPasteOperation(isLocal)
   let g:netrw_pasteaction = ""
   hi! link netrwMarkFile WildMenu
   return ""
endfunction

function! netrw#custom#SetPasteOpAsMove(isLocal)
   let marked=netrw#Expose("netrwmarkfilelist")
   if type(marked) != type([]) || len(marked) == 0
      call s:NetrwMarkFileBinding()
   endif
   let g:netrw_pasteaction = "move"
   hi! link netrwMarkFile netrwMoveMark
   return ""
endfunction

function! netrw#custom#SetPasteOpAsCopy(isLocal)
   let marked=netrw#Expose("netrwmarkfilelist")
   if type(marked) != type([]) || len(marked) == 0
      call s:NetrwMarkFileBinding()
   endif
   let g:netrw_pasteaction = "copy"
   hi! link netrwMarkFile netrwCopyMark
   return ""
endfunction

"  --------------- "
"  soft and hard links (unix only)
"  --------------- "
function! s:CreateLink(options)
   let marked=netrw#Expose("netrwmarkfilelist")
   if has("unix")
      let baseCmd="ln"
   else
      echomsg "Links are not supported on your system"
      return
   endif

   call netrw#Modify("netrwmarkfilelist", [])
   call netrw#Modify('netrwmarkfilemtch_{bufnr("%")}',"")
   call netrw#custom#ResetPasteOperation(1)

   for file in marked
      let file = escape(file, "'")
      " let err = system(baseCmd.a:options." '".file."' '".getcwd()."'")
      let err = system(printf("%s %s '%s' '%s'", baseCmd, a:options, file, getcwd()))
      " TODO getcwd only works cuz g:netrw_keepdir is set, use netrw native api instead
      if !empty(err)
         echoerr "Error creating symlink for ".file.': '.err
      endif
   endfor
endfunction

function! netrw#custom#CreateSymLink(isLocal)
   call s:CreateLink('-s')
   return ["refresh"]
endfunction

function! netrw#custom#CreateRelLink(isLocal)
   call s:CreateLink('-sr')
   return ["refresh"]
endfunction

function! netrw#custom#CreateHardLink(isLocal)
   call s:CreateLink('-h')
   return ["refresh"]
endfunction

" Copy File location
function! netrw#custom#CopyLocation(isLocal)
	let loc = getcwd()."/".netrw#Call('NetrwGetWord')
   call setreg(v:register, loc)
   echo "copied ".loc." to clipboard"
   return ""
endfunction

"  --------------- "
"  Preview mode
"  --------------- "
function! netrw#custom#PreviewFile()
   let file = netrw#Call("NetrwGetWord")
   if !isdirectory(file)
      call netrw#Call("NetrwPreview", netrw#Call("NetrwBrowseChgDir", 1, file,1))
   endif
endfunction

function! netrw#custom#TogglePreviewMode(isLocal)
   if !exists('#NetrwPreviewMode#CursorMoved')
      augroup NetrwPreviewMode
         autocmd!
         autocmd CursorMoved * if &ft == 'netrw' | call netrw#custom#PreviewFile()
      augroup END
      echom "Preview mode: On"
      call NetrwPreviewFile()
   else
      augroup NetrwPreviewMode
         autocmd!
      augroup END
      echom "Preview mode: Off"
      pclose
   endif
endfunction


"  --------------- "
"  Create File/Directory
"  --------------- "
" TODO
fu! s:inputHL(input)
	return [[0, len(a:input), 'Directory']]
endfu

fu! netrw#custom#NewFileOrDir(islocal)
	if !has('unix')
		echoerr 'Only on Unix systems'
		return
	endif

	let path = input({
				\	'prompt': 'Create ' . getcwd()->fnamemodify(':~:t') . '/',
				\  'highlight': function('s:inputHL')
				\})
	if empty(path)
		return
	elseif path[len(path) - 1] == '/'
		let dir=path
		let file=''
	else
		let dir = fnamemodify(path, ':h')
		let file = fnamemodify(path, ':t')
	endif

	if !empty(dir)
		call system(['mkdir', '-p', dir])
	endif

	if !empty(file)
		call system(['touch', path])
	endif

	return ['refresh']
endfu
