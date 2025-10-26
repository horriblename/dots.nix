if vim.fn.has("linux") then
	local ok, data = pcall(require, 'cwatch.watcher.linux')
	if ok then
		return data
	else
		vim.notify(
			"could not initialize inotify backend, falling back to uv: " .. data,
			vim.log.levels.WARN
		)
	end
end

return require('cwatch.watcher.uv')
