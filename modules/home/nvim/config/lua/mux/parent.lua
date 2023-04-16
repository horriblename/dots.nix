local M = {}

function M.register_waiting(client)
	-- local win = vim.fn.win_getid()
	local addr = vim.fn.sockconnect("pipe", client, { rpc = true })
	local cmd = ([[augroup nvr
autocmd BufDelete <buffer> silent! call rpcrequest(%d, "print", "did one")
autocmd VimLeave * if exists("v:exiting") && v:exiting > 0 | silent! call rpcnotify(%d, "Exit", v:exiting) | endif
augroup END
  ]]):format(addr, addr)
	vim.cmd(cmd)
end

function M.on_buf_del(chan) end

return M
