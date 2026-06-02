local function cdToGitRoot()
	local state = MiniFiles.get_explorer_state()
	if state == nil then
		vim.notify("Tried to cdToGitRoot when mini.files is not open?", vim.log.levels.ERROR)
	end
	local res = vim.system(
		{ "git", "-C", state.branch[state.depth_focus], "rev-parse", "--show-toplevel" },
		{ text = true }
	):wait()
	if res.code == 0 then
		MiniFiles.set_branch({ vim.trim(res.stdout) })
	else
		local msg = "Could not find git root directory:\n" .. res.stderr
		vim.notify(msg, vim.log.levels.ERROR)
	end
end

vim.keymap.set("n", "g0", cdToGitRoot, {
	buffer = true,
	desc = "Go to Git Root",
})
vim.keymap.set("n", "-", MiniFiles.go_out, {
	buffer = true,
	desc = "Go to Parent",
})
