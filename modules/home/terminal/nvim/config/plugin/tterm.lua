local group = vim.api.nvim_create_augroup("toggleterm_tab_closed", { clear = true })
vim.api.nvim_create_autocmd("TabClosed", {
	group = group,
	callback = function() require("tterm").on_tab_closed() end
})

local opts = { remap = false }
vim.keymap.set('t', '<M-m>', '<C-\\><C-n>', opts)
vim.keymap.set({ 'n', 'i', 'x', 's', 't' }, '<M-m>w', function()
	require('tterm').toggleterm()
end, opts)
vim.keymap.set({ 'n', 'i', 'x', 's', 't' }, '<M-m>n', function()
	require('tterm').new_term()
end, opts)
