local function splitWords(text)
	local iter = string.gmatch(text, '[A-Z]*[a-z0-9]*')

	return function()
		local word = iter()
		while word == '' do word = iter() end
		return word
	end
end

function _G.kebab_case(text)
	local buf = require('string.buffer').new()
	local words = splitWords(text)
	local first = words()
	if first == nil then return "" end

	buf:put(first:lower())
	for word in words do
		buf:putf('-%s', word:lower())
	end

	return buf:get()
end

function _G.snake_case(text)
	local buf = require('string.buffer').new()
	local words = splitWords(text)
	local first = words()
	if first == nil then return "" end

	buf:put(first:lower())
	for word in words do
		buf:putf('_%s', word:lower())
	end

	return buf:get()
end

function _G.camelCase(text)
	local buf = require('string.buffer').new()
	local words = splitWords(text)
	local first = words()
	if first == nil then return "" end

	buf:putf('%s', first:lower())
	for word in words do
		buf:putf('%s%s', word:sub(1, 1):upper(), word:sub(2):lower())
	end

	return buf:get()
end

function _G.PascalCase(text)
	local buf = require('string.buffer').new()
	local words = splitWords(text)
	local first = words()
	if first == nil then return "" end

	buf:putf('%s%s', first:sub(1, 1):upper(), first:sub(2):lower())
	for word in words do
		buf:putf('%s%s', word:sub(1, 1):lower(), word:sub(2):lower())
	end

	return buf:get()
end

function _G.CONST_CASE(text)
	local buf = require('string.buffer').new()
	local words = splitWords(text)
	local first = words()
	if first == nil then return "" end

	buf:putf('%s', first:upper())
	for word in words do
		buf:putf('_%s', word:upper())
	end

	return buf:get()
end

local function withDesc(desc)
	return { desc = desc }
end

vim.keymap.set('n', '<leader>ck', '"zciw<C-r>=v:lua.kebab_case(@z)<CR><Esc>', withDesc('to kebab-case'))
vim.keymap.set('n', '<leader>cs', '"zciw<C-r>=v:lua.snake_case(@z)<CR><Esc>', withDesc('to snake_case'))
vim.keymap.set('n', '<leader>cp', '"zciw<C-r>=v:lua.PascalCase(@z)<CR><Esc>', withDesc('to PascalCase'))
vim.keymap.set('n', '<leader>cc', '"zciw<C-r>=v:lua.camelCase(@z)<CR><Esc>', withDesc('to camelCase'))
vim.keymap.set('n', '<leader>cC', '"zciw<C-r>=v:lua.CONST_CASE(@z)<CR><Esc>', withDesc('to CONST_CASE'))

vim.keymap.set('x', '<leader>ck', '"zc<C-r>=v:lua.kebab_case(@z)<CR><Esc>', withDesc('to kebab-case'))
vim.keymap.set('x', '<leader>cs', '"zc<C-r>=v:lua.snake_case(@z)<CR><Esc>', withDesc('to snake_case'))
vim.keymap.set('x', '<leader>cp', '"zc<C-r>=v:lua.PascalCase(@z)<CR><Esc>', withDesc('to PascalCase'))
vim.keymap.set('x', '<leader>cc', '"zc<C-r>=v:lua.camelCase(@z)<CR><Esc>', withDesc('to camelCase'))
vim.keymap.set('x', '<leader>cC', '"zc<C-r>=v:lua.CONST_CASE(@z)<CR><Esc>', withDesc('to CONST_CASE'))
