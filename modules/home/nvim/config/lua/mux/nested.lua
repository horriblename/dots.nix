local M = {}

local remote_wait = function(...)
	local remote = os.getenv("NVIM")
	local listen = vim.v.servername

	if not listen or not remote then
		return
	end

	local cmd = {
		"nvim",
		"--server",
		"--remote",
		("+lua require 'mux.parent'.register_waiting('%s')"):format(listen),
		"--",
	}

	vim.list_extend(cmd, ...)
	vim.fn.system(cmd)
end

function M.remote_wait()
	local files = vim.fn.argv()
	remote_wait(files)
	vim.cmd("argd *")
end

return M
