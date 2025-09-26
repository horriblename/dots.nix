---@type lint.Linter
return {
	cmd = "go-sumtype",
	args = { "./..." },
	append_fname = false,
	stream = "stderr",
	-- cwd = vim.fs.root(0, "go.mod"),
	ignore_exitcode = true,
	parser = require("lint.parser").from_errorformat([[%f:%l:%c: %m]], {}),
}
