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

local function get_selection()
	-- does not handle rectangular selection
	local s_start = vim.fn.getpos "."
	local s_end = vim.fn.getpos "v"
	local lines = vim.fn.getregion(s_start, s_end)
	return lines
end

local function ui_open(file)
	local found = vim.fn.findfile(file, vim.o.path, 1)
	if found ~= '' then
		vim.ui.open(found)
	else
		vim.notify("File not found: " .. file, vim.log.levels.ERROR)
	end
end

vim.keymap.set("n", "gx", function() ui_open(vim.fn.expand("<cfile>")) end)
vim.keymap.set("x", "gx", function()
	-- escape, otherwise getVisualSelection returns the previous selection
	local lines = get_selection()
	ui_open(lines[1])
end)
