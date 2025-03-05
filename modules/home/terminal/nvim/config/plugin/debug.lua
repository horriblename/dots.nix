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
	{ __index = function(_, key) return vim.fn.getreg(key) end }
)
_G.reg = vim.reg
