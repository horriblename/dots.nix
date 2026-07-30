local config = {
	cmd = "keep-sorted",
	default_options = "group=true"
}

vim.api.nvim_create_user_command("KeepSorted", function(opt)
	local input = vim.api.nvim_buf_get_lines(0, opt.line1 - 1, opt.line2, true)
	table.insert(input, 1, vim.bo.commentstring:format("keep-sorted start " .. opt.args))
	table.insert(input, vim.bo.commentstring:format("keep-sorted end"))
	local result = vim.system({ config.cmd, "-" }, {
		text = true,
		stdin = input,
	}):wait()

	if result.code == 0 then
		local lines = vim.iter(vim.gsplit(result.stdout, "\n", {}))
			:skip(1)
			:totable()
		lines[#lines] = nil -- remove final "\n"
		lines[#lines] = nil -- remove "# keep-sorted end"
		vim.api.nvim_buf_set_lines(0, opt.line1 - 1, opt.line2, true, lines)
	else
		vim.notify(result.stderr, vim.log.levels.ERROR)
	end
end, {
	nargs = "*",
	range = "%",
	complete = function()
		return {
			"block=true",
			"group_prefixes=",
			"sticky_prefixes=",
			"sticky_comments=",
			"skip_lines=1",
			"case=false",
			"numeric=true",
			"by_regex=",
			"prefix_order=c,b",
			-- post sorting options
			"remove_duplicates=true",
			"newline_separated=true",
		}
	end
})
