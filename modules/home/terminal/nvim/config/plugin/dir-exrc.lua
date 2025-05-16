local augroup = vim.api.nvim_create_augroup("dots_dir_exrc", { clear = true })

vim.api.nvim_create_autocmd("DirChanged", {
	group = augroup,
	callback = function()
		local path = vim.fs.joinpath(vim.v.event.cwd, ".nvim.lua")
		local content = vim.secure.read(path)
		if content then
			assert(loadstring(content, path))()
			vim.notify("dir_exrc: loaded " .. path)
		end
	end,
})
