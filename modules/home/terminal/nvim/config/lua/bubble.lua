local M = {}

---@type table<integer, integer[]>
local tracked_bufs = {}

---@param args string[]
---@return boolean is_nested
function M.try_attach_parent(args)
	local addr = vim.env.NVIM or os.getenv("NVIM_LISTEN_ADDRESS")
	if not addr or addr == "" then
		return false
	end

	if #args == 0 then
		return false
	end

	-- TODO: support "tcp" mode?
	local chan = vim.fn.sockconnect("pipe", addr, { rpc = true })
	if chan == 0 then
		error("could not connect to parent socket " .. addr)
	end
	local client_sock = vim.v.servername

	vim.cmd('%argdelete') -- clear args as it may prevent clean shutdown
	-- TODO: support tcp socket?
	vim.rpcrequest(chan, "nvim_exec_lua", "require('bubble').parent_open_files(...)",
		{ "pipe", client_sock, unpack(args) })
	return true
end

---@generic T
---@param list T[]
---@param item T
---@return integer?
local function list_index(list, item)
	for i, el in ipairs(list) do
		if el == item then
			return i
		end
	end
end

local function on_parent_done(child_chan)
	vim.rpcnotify(child_chan, "nvim_command", "quit")
	vim.fn.chanclose(child_chan)
end

function M.parent_open_files(sock_mode, child_sock, ...)
	local child_chan = vim.fn.sockconnect(sock_mode, child_sock, { rpc = true })
	if child_chan == 0 then
		error("could not connect to child socket " .. child_sock)
	end
	local nargs = select('#', ...)
	if nargs == 0 then
		on_parent_done(child_chan)
		return
	elseif nargs == 1 then
		vim.cmd.edit(...)
	else
		vim.cmd.tabnew()
		vim.cmd.args(...)
		vim.cmd('vertical all')
	end

	local group = vim.api.nvim_create_augroup("bubble_" .. child_chan, { clear = false })

	local bufs = vim.iter({ ... }):map(vim.fn.bufnr):totable()
	tracked_bufs[child_chan] = bufs

	for _, buf in ipairs(bufs) do
		vim.bo[buf].bufhidden = "wipe"
		vim.api.nvim_create_autocmd("BufWipeout", {
			group = group,
			buffer = buf,
			once = true,
			callback = function()
				local idx = list_index(bufs, buf)
				if idx then
					table.remove(bufs, idx)
					vim.rpcnotify(child_chan, "nvim_echo", {
						{ string.format('closed %s. %d files left', vim.fn.bufname(buf), #bufs) },
					})
				end
				if #bufs == 0 then
					on_parent_done(child_chan)
					vim.api.nvim_del_augroup_by_id(group)
				end
			end
		})
	end
end

return M
