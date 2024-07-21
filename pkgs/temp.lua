vim.keymap.set('n', "<leader>ha", function() require "harpoon.mark".add_file() end)
vim.keymap.set('n', "<leader>hh", function() require "harpoon.ui".toggle_quick_menu() end)
vim.keymap.set('n', "<C-.>", function()
	if vim.v.count == 0 then
		return "lua require('harpoon.ui').toggle_quick_menu()"
	end
	return (":lua require('harpoon.ui').nav_file(%d)<CR>"):format(vim.v.count)
end, { expr = true, noremap = true })
