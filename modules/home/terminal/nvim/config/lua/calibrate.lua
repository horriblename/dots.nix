M = {}

local profiles = { 'modern', 'xterm', 'konsole' }

M.calibrate = function(profile)
	if profile == nil then
		print('Select a profile:')
		for i, p in ipairs(profiles) do
			print(i, ': ', p)
		end

		local inp = vim.fn.input('> ')
		inp = tonumber(inp)

		if inp == nil or inp > #profiles then
			print "invalid input"
			return
		end

		profile = profiles[inp]
	end

	pcall(vim.keymap.del, 'i', '<C-H>')
	pcall(vim.keymap.del, 'i', '<BS>')
	pcall(vim.keymap.del, 'i', '<C-BS>')

	if profile == 'xterm' then
		vim.keymap.set({ 'i', 'c' }, '<BS>', '<c-w>', { noremap = true })
	elseif profile == 'konsole' then
		vim.keymap.set({ 'i', 'c' }, '<C-h>', '<C-w>', { noremap = true })
	else
		vim.keymap.set('i', '<C-H>', '<Left>', { noremap = true })
		vim.keymap.set('i', '<C-BS>', '<C-W>', { noremap = true })
	end
end

return M
