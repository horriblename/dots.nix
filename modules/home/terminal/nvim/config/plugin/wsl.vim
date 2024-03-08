if glob("/proc/sys/fs/binfmt_misc/WSLInterop")->empty()
	finish
endif
let g:clipboard = {
			\   'name': 'WslClipboard',
			\   'copy': {
			\      '*': 'clip.exe',
			\    },
			\   'paste': {
			\      '*': 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
			\   },
			\   'cache_enabled': 0,
			\ }