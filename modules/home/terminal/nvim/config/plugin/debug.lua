_G.rerequire = function(mod)
	for key, _ in pairs(package.loaded) do
		if string.find(key, mod) then
			package.loaded[mod] = nil;
		end
	end
	return require(mod)
end

vim.reg = setmetatable(
	{ set = vim.fn.setreg },
	{ __index = function(_, key) return vim.fn.getreg(key) end }
)
_G.reg = vim.reg
