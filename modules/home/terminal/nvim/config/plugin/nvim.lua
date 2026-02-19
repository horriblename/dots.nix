-- neovim specific config
local function diagnosticJump(dir)
	return function()
		vim.diagnostic.jump({
			count = dir * vim.v.count1,
			float = true,
			wrap = false,
		})
	end
end
vim.keymap.set("n", "[d", diagnosticJump(-1))
vim.keymap.set("n", "]d", diagnosticJump(1))

vim.diagnostic.config({
	float = {
		suffix = function(diag)
			return string.format(" [%s by %s]", diag.code, diag.source)
		end
	},
	severity_sort = true,
})
