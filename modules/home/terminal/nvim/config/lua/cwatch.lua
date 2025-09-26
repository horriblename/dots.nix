local M = {}

local watchers = {}

local function stop_watcher(path)
	if watchers[path] then
		pcall(function()
			watchers[path]:stop()
		end)
		watchers[path] = nil
		vim.notify("Stopped watching: " .. path, vim.log.levels.INFO)
	end
end

local function on_change(err, fname, events)
	if err then
		vim.notify("Watcher error: " .. err, vim.log.levels.ERROR)
		return
	end
	-- Do work...
	vim.cmd("checktime")
	vim.cmd("cgetfile")

	-- Debounce: restart watcher
	stop_watcher(fname)
	vim.schedule(function()
		M.watch_file(fname)
	end)
end

function M.watch_file(fname)
	local fullpath = vim.fn.fnamemodify(fname, ":p")
	-- If already watching, stop first
	stop_watcher(fullpath)

	local w = vim.uv.new_fs_event()
	local ok, err = w:start(
		fullpath,
		{},
		vim.schedule_wrap(function(...)
			on_change(...)
		end)
	)
	if ok then
		watchers[fullpath] = w
		vim.notify("Watching: " .. fullpath, vim.log.levels.INFO)
	else
		vim.notify(("Failed to watch %s: %s"):format(fullpath, err), vim.log.levels.ERROR)
	end
end

function M.unwatch_file(fname)
	local fullpath = vim.fn.fnamemodify(fname, ":p")
	stop_watcher(fullpath)
end

function M.unwatch_all()
	for path, _ in pairs(watchers) do
		stop_watcher(path)
	end
end

function M.list_watched()
	return vim.tbl_keys(watchers)
end

return M
