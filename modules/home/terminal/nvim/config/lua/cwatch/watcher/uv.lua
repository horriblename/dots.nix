---@class Watcher
---@field watchers any[]
local UvWatcher = {}

function UvWatcher.new()
	return setmetatable({ watchers = {} }, { __index = UvWatcher })
end

function UvWatcher:stop_watcher(path)
	if self.watchers[path] then
		pcall(function()
			self.watchers[path]:stop()
		end)
		self.watchers[path] = nil
		vim.notify("Stopped watching: " .. path, vim.log.levels.INFO)
	end
end

function UvWatcher:on_inotify_readable(err, path, events)
	if err then
		vim.notify("Watcher error: " .. err, vim.log.levels.ERROR)
		return
	end
	-- Do work...
	vim.cmd("checktime")
	vim.cmd.cgetfile(path)

	-- Debounce: restart watcher
	self:stop_watcher(path)
	vim.schedule(function()
		self:watch(path)
	end)
end

function UvWatcher:watch(full_path)
	-- If already watching, stop first
	self:stop_watcher(full_path)

	local w = vim.uv.new_fs_event()
	local ok, err = w:start(
		full_path,
		{},
		vim.schedule_wrap(function(...)
			self:on_inotify_readable(...)
		end)
	)
	if ok then
		self.watchers[full_path] = w
	else
		return ("Failed to watch %s: %s"):format(full_path, err)
	end
end

function UvWatcher:unwatch(full_path)
	self:stop_watcher(full_path)
end

function UvWatcher:unwatch_all()
	for path, _ in pairs(self.watchers) do
		self:stop_watcher(path)
	end
end

function UvWatcher:list_watched()
	return vim.tbl_keys(self.watchers)
end

return UvWatcher
