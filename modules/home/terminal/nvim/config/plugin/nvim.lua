-- neovim specific config
local function diagnosticJump(dir)
	return function()
		vim.diagnostic.jump({
			count = dir * vim.v.count1,
			wrap = false,
			on_jump = function(_, bufnr)
				vim.diagnostic.open_float({
					scope = 'cursor',
					bufnr = bufnr,
					focus = false,
				})
			end
		})
	end
end
vim.keymap.set("n", "[d", diagnosticJump(-1))
vim.keymap.set("n", "]d", diagnosticJump(1))

vim.diagnostic.config({
	float = {
		suffix = function(diag)
			return string.format(" [%s by %s]", diag.code, diag.source), "Comment"
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
	local found = vim.fn.findfile(file, vim.o.path, 1) --[[@as string]]
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

-- sub-mode mapping
local function enterSubmode(prefix, key, possible)
	prefix = vim.api.nvim_replace_termcodes(prefix, true, false, true)
	key = vim.api.nvim_replace_termcodes(key, true, false, true)
	vim.fn.feedkeys(prefix .. key, 'nx')
	vim.api.nvim__redraw({ cursor = true, valid = false })
	local c = vim.fn.getcharstr()
	while vim.list_contains(possible, c) do
		c = vim.api.nvim_replace_termcodes(c, true, false, true)
		vim.fn.feedkeys(prefix .. c, 'nx')
		vim.api.nvim__redraw({ cursor = true, valid = false })
		c = vim.fn.getcharstr()
	end

	if c ~= '' then
		vim.fn.feedkeys(c)
	end
end

local groupWrapMove = { 'j', 'k' }
vim.keymap.set("n", "gj", function() enterSubmode('g', 'j', groupWrapMove) end)
vim.keymap.set("n", "gk", function() enterSubmode('g', 'k', groupWrapMove) end)
vim.keymap.set("x", "gj", function() enterSubmode('g', 'j', groupWrapMove) end)
vim.keymap.set("x", "gk", function() enterSubmode('g', 'k', groupWrapMove) end)

local groupSideScroll = { 'L', 'H' }
vim.keymap.set("n", "zL", function() enterSubmode('z', 'L', groupSideScroll) end)
vim.keymap.set("n", "zH", function() enterSubmode('z', 'H', groupSideScroll) end)
vim.keymap.set("x", "zL", function() enterSubmode('z', 'L', groupSideScroll) end)
vim.keymap.set("x", "zH", function() enterSubmode('z', 'H', groupSideScroll) end)

local groupFold = { 'o', 'c', 'O', 'C' }
vim.keymap.set("n", "zo", function() enterSubmode('z', 'o', groupFold) end)
vim.keymap.set("n", "zc", function() enterSubmode('z', 'c', groupFold) end)
vim.keymap.set("x", "zo", function() enterSubmode('z', 'o', groupFold) end)
vim.keymap.set("x", "zc", function() enterSubmode('z', 'c', groupFold) end)

local groupResizeWin = { '-', '+', '<', '>' }
vim.keymap.set("n", "<C-W>-", function() enterSubmode("<C-W>", '-', groupResizeWin) end)
vim.keymap.set("x", "<C-W>-", function() enterSubmode("<C-W>", '-', groupResizeWin) end)
vim.keymap.set("n", "<C-W>+", function() enterSubmode("<C-W>", '+', groupResizeWin) end)
vim.keymap.set("x", "<C-W>+", function() enterSubmode("<C-W>", '+', groupResizeWin) end)
vim.keymap.set("n", "<C-W><", function() enterSubmode("<C-W>", '<', groupResizeWin) end)
vim.keymap.set("x", "<C-W><", function() enterSubmode("<C-W>", '<', groupResizeWin) end)
vim.keymap.set("n", "<C-W>>", function() enterSubmode("<C-W>", '>', groupResizeWin) end)
vim.keymap.set("x", "<C-W>>", function() enterSubmode("<C-W>", '>', groupResizeWin) end)
