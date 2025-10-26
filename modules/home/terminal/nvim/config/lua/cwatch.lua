local M = {}
---@type Watcher
local Watcher = require('cwatch.watcher')
local watcher = Watcher.new()

function M.watch_file(fname)
	local fullpath = vim.fn.fnamemodify(fname, ":p")
	-- If already watching, stop first
	local err = watcher:watch(fullpath)
	if err ~= nil then
		vim.notify(err)
	end
end

function M.unwatch_file(fname)
	local fullpath = vim.fn.fnamemodify(fname, ":p")
	watcher:unwatch(fullpath)
end

function M.unwatch_all()
	watcher:unwatch_all()
end

function M.list_watched()
	return watcher:list_watched()
end

return M
