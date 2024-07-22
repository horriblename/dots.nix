if os.getenv("ZELLIJ") == nil then
	return
end

local function renameTab()
	vim.system({ 'zellij', 'action', 'rename-tab', vim.fs.basename(vim.fn.getcwd()) })
end

local group = vim.api.nvim_create_augroup("ZellijIntegration", { clear = true })

vim.api.nvim_create_autocmd("DirChanged", {
	group = group,
	once = true,
	callback = renameTab,
})

if vim.v.vim_did_enter then
	renameTab()
else
	vim.api.nvim_create_autocmd("VimEnter",
		{ group = group, once = true, callback = renameTab })
end
