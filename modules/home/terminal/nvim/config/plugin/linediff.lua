---@param opt {line: boolean?}
---@return function
local function execute_operator(opt)
	return function()
		vim.go.operatorfunc = [[v:lua.require'linediff'.operatorfunc]]
		if opt.line then
			return "g@l"
		else
			return "g@"
		end
	end
end
vim.api.nvim_create_user_command("LineDiffMark", function(opts)
	require("linediff").mark_region(opts.line1 - 1, opts.line2 - 1)
end, { range = true })

vim.keymap.set("n", "<leader>==", execute_operator({ line = true }), { expr = true })
vim.keymap.set("n", "<leader>=", execute_operator({}), { expr = true })
vim.keymap.set("x", "<leader>=", ":LineDiffMark<CR>", {})
