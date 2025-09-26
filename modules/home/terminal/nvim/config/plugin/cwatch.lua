vim.api.nvim_create_user_command("CWatch", function(opts)
	local file = opts.args ~= "" and opts.args or vim.o.errorfile
	require("cwatch").watch_file(file)
end, {
	nargs = "?",
	complete = "file",
})

vim.api.nvim_create_user_command("CUnwatch", function(opts)
	local file = opts.args ~= "" and opts.args or vim.o.errorfile
	require("cwatch").unwatch_file(file)
end, {
	nargs = "?",
	complete = function()
		return vim.iter(require("cwatch").list_watched())
			:map(function(fname)
				return vim.fn.fnamemodify(fname, ":~:.")
			end)
			:totable()
	end,
})

vim.api.nvim_create_user_command("CUnwatchAll", function(_)
	require("cwatch").unwatch_all()
end, {})
