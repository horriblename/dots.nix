local notesFile = '.NOTES.md'

vim.api.nvim_create_user_command('NotesToggle', function()
	if vim.fn.expand('%:t') == notesFile then
		vim.cmd.edit('#')
		return
	end

	local win = vim.fn.bufwinnr(notesFile)
	if win ~= -1 then
		vim.cmd(win .. 'wincmd w')
	else
		vim.cmd.edit(notesFile)
	end
end, {})

vim.keymap.set('n', '<leader>nn', ':NotesToggle<CR>')
vim.keymap.set('n', '<leader>nv', ':vsplit | NotesToggle<CR>')
