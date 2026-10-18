local function
withDesc(desc)
	return { desc = desc }
end

vim.keymap.set('n', '<leader>ck',
	[["zciw<C-r>=v:lua.require'case.to'.kebab_case(@z)<CR><Esc>]],
	withDesc('to kebab-case'))
vim.keymap.set('n', '<leader>c-',
	[["zciw<C-r>=v:lua.require'case.to'.kebab_case(@z)<CR><Esc>]],
	withDesc('to kebab-case'))
vim.keymap.set('n', '<leader>cs',
	[["zciw<C-r>=v:lua.require'case.to'.snake_case(@z)<CR><Esc>]],
	withDesc('to snake_case'))
vim.keymap.set('n', '<leader>c_',
	[["zciw<C-r>=v:lua.require'case.to'.snake_case(@z)<CR><Esc>]],
	withDesc('to snake_case'))
vim.keymap.set('n', '<leader>c ',
	[["zciw<C-r>=v:lua.require'case.to'.space_case(@z)<CR><Esc>]],
	withDesc('to space-separated'))
vim.keymap.set('n', '<leader>cp',
	[["zciw<C-r>=v:lua.require'case.to'.PascalCase(@z)<CR><Esc>]],
	withDesc('to PascalCase'))
vim.keymap.set('n', '<leader>cc',
	[["zciw<C-r>=v:lua.require'case.to'.camelCase(@z)<CR><Esc>]],
	withDesc('to camelCase'))
vim.keymap.set('n', '<leader>cC',
	[["zciw<C-r>=v:lua.require'case.to'.CONST_CASE(@z)<CR><Esc>]],
	withDesc('to CONST_CASE'))

vim.keymap.set('x', '<leader>ck',
	[["zc<C-r>=v:lua.require'case.to'.kebab_case(@z)<CR><Esc>]],
	withDesc('to kebab-case'))
vim.keymap.set('x', '<leader>cs',
	[["zc<C-r>=v:lua.require'case.to'.snake_case(@z)<CR><Esc>]],
	withDesc('to snake_case'))
vim.keymap.set('x', '<leader>c ',
	[["zc<C-r>=v:lua.require'case.to'.space_case(@z)<CR><Esc>]],
	withDesc('to space-separated'))
vim.keymap.set('x', '<leader>cp',
	[["zc<C-r>=v:lua.require'case.to'.PascalCase(@z)<CR><Esc>]],
	withDesc('to PascalCase'))
vim.keymap.set('x', '<leader>cc',
	[["zc<C-r>=v:lua.require'case.to'.camelCase(@z)<CR><Esc>]],
	withDesc('to camelCase'))
vim.keymap.set('x', '<leader>cC',
	[["zc<C-r>=v:lua.require'case.to'.CONST_CASE(@z)<CR><Esc>]],
	withDesc('to CONST_CASE'))
