if os.getenv("ZELLIJ") == nil then
	return
end

local function renameTab()
	vim.system({ 'zellij', 'action', 'rename-tab', vim.fn.getcwd() })
end

if vim.v.vim_did_enter then
	renameTab()
	return
end

local group = vim.api.nvim_create_augroup("ZellijRenameTab", { clear = true })

vim.api.nvim_create_autocmd("VimEnter", {
	group = group,
	once = true,
	callback = renameTab,
})
