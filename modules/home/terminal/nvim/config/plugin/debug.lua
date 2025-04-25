function _G.unload(patt)
	for key, _ in pairs(package.loaded) do
		if string.find(key, '^' .. patt) then
			package.loaded[patt] = nil
			vim.notify('unloaded ' .. key)
		end
	end
end

_G.rerequire = function(mod)
	_G.unload(mod)
	return require(mod)
end

vim.reg = setmetatable(
	{ set = vim.fn.setreg },
	{
		__call = function(_, key) return vim.fn.getreg(key) end,
		__index = function(_, key) return vim.fn.getreg(key) end,
		__newindex = function(_, key, value) vim.fn.setreg(key, value) end,
	}
)
_G.reg = vim.reg

_G.F = function(...) return require('F')(...) end
_G.E = setmetatable({}, {
	__index = function(_, env)
		return os.getenv(env)
	end,
	__newindex = function(_, k, v)
		vim.fn.setenv(k, v)
	end
})

-- user command that opens a file in the runtime path
vim.api.nvim_create_user_command("EditRuntime", function(args)
	local files = vim.api.nvim__get_runtime({ args.args }, false, {})
	if files[1] then
		vim.cmd.edit(files[1])
	else
		vim.notify(string.format('no file %s on runtimepath', args.args), vim.log.levels.ERROR)
	end
end, {
	nargs = 1,
	complete = "runtime",
})
