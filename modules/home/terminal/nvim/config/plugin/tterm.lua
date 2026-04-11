local group = vim.api.nvim_create_augroup("toggleterm_general_hooks", { clear = true })
vim.api.nvim_create_autocmd("TabClosed", {
	group = group,
	callback = function() require("tterm").on_tab_closed() end
})
vim.api.nvim_create_autocmd("WinEnter", {
	group = group,
	callback = vim.schedule_wrap(function()
		if not vim.w.toggleterm_win_offset
			and vim.api.nvim_win_get_config(0).relative == ''
		then
			require("tterm").close_floating_wins(vim.api.nvim_win_get_tabpage(0))
		end
	end),
})

local opts = { remap = false }
vim.keymap.set('t', '<M-m>', '<C-\\><C-n>', opts)
vim.keymap.set({ 'n', 'i', 'x', 's', 't' }, '<M-m>w', function()
	require('tterm').toggleterm()
end, opts)
vim.keymap.set({ 'n', 'i', 'x', 's', 't' }, '<M-m>n', function()
	require('tterm').new_term()
end, opts)
