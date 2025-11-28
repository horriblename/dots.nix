local ok, data = pcall(require('bubble').try_attach_parent, vim.fn.argv())
if not ok then
	vim.notify(data, vim.log.levels.ERROR)
elseif data then
	-- HACK: prevent unnecessary work (and the log that comes with it).
	-- I should just do something in init.lua maybe?
	-- Can I prevent opening the files completely?
	vim.o.eventignore = "all"
	-- go into Ex-mode to avoid drawing things
	-- (doesn't work :c)
	vim.cmd("normal! gQ")
end
