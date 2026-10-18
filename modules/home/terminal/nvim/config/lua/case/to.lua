local M = {}

local splitAuto = require("case.split").auto

function M.kebab_case(text, splitter)
	local buf = require('string.buffer').new()
	local words = (splitter or splitAuto)(text)
	local first = words()
	if first == nil then return "" end

	buf:put(first:lower())
	for word in words do
		buf:putf('-%s', word:lower())
	end

	return buf:get()
end

function M.snake_case(text, splitter)
	local buf = require('string.buffer').new()
	local words = (splitter or splitAuto)(text)
	local first = words()
	if first == nil then return "" end

	buf:put(first:lower())
	for word in words do
		buf:putf('_%s', word:lower())
	end

	return buf:get()
end

function M.space_case(text, splitter)
	local buf = require('string.buffer').new()
	local words = (splitter or splitAuto)(text)
	local first = words()
	if first == nil then return "" end

	buf:put(first:lower())
	for word in words do
		buf:putf(' %s', word:lower())
	end

	return buf:get()
end

function M.camelCase(text, splitter)
	local buf = require('string.buffer').new()
	local words = (splitter or splitAuto)(text)
	local first = words()
	if first == nil then return "" end

	buf:putf('%s', first:lower())
	for word in words do
		buf:putf('%s%s', word:sub(1, 1):upper(), word:sub(2):lower())
	end

	return buf:get()
end

function M.PascalCase(text, splitter)
	local buf = require('string.buffer').new()
	local words = (splitter or splitAuto)(text)
	local first = words()
	if first == nil then return "" end

	buf:putf('%s%s', first:sub(1, 1):upper(), first:sub(2):lower())
	for word in words do
		buf:putf('%s%s', word:sub(1, 1):lower(), word:sub(2):lower())
	end

	return buf:get()
end

function M.CONST_CASE(text, splitter)
	local buf = require('string.buffer').new()
	local words = (splitter or splitAuto)(text)
	local first = words()
	if first == nil then return "" end

	buf:putf('%s', first:upper())
	for word in words do
		buf:putf('_%s', word:upper())
	end

	return buf:get()
end

return M
