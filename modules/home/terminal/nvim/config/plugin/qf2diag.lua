local group = vim.api.nvim_create_augroup("qf-to-diagnostics-sync", { clear = true })
-- NOTE: I wanted to separate namespace of different error files, such that
-- `:cfile errors.err` and `:cfile foo.err` can both have their diagnostics
-- present at the same time, but couldn't figure out when to clean up a
-- namespace. Integrating directly with :CWatch may solve this problem
local diag_ns = vim.api.nvim_create_namespace("qf-to-diagnostics-sync")

local function squash_qflist(list)
	local squashed = {}
	local acc = list[1]
	if acc == nil then
		return {}
	end
	local strbuf = require("string.buffer")
	local desc = strbuf.new()
	desc:put(acc.text)
	for item in vim.iter(list):skip(1) do
		if item.valid == 1 then
			acc.text = desc:get()
			table.insert(squashed, acc)

			acc = item
			desc:put(item.text)
		else
			desc:put("\n", item.text)
		end
	end
	acc.text = desc:get()
	table.insert(squashed, acc)
	return squashed
end

function _G.DiagnosticFromQfList()
	vim.diagnostic.reset(diag_ns)
	local list = squash_qflist(vim.fn.getqflist())
	local bufset = {}
	for _, diag in ipairs(vim.diagnostic.fromqflist(list)) do
		if not bufset[diag.bufnr] then
			bufset[diag.bufnr] = { diag }
		else
			table.insert(bufset[diag.bufnr], diag)
		end
	end
	for buf, diags in pairs(bufset) do
		vim.diagnostic.set(diag_ns, buf, diags, {})
	end
end

vim.api.nvim_create_autocmd({ "QuickFixCmdPost" }, {
	group = group,
	callback = function(ev)
		if ev.match:match('^Diagnostics') then
			return
		end
		DiagnosticFromQfList()
	end,
})

vim.api.nvim_create_user_command("Qf2Diag", function(ev)
	if ev.bang then
		vim.diagnostic.reset(diag_ns)
	else
		_G.DiagnosticFromQfList()
	end
end, {
	desc = "Populate Diagnostics with Quickfix items",
	bang = true
})
vim.keymap.set('n', '<leader>xd', ":Qf2Diag<CR>")
