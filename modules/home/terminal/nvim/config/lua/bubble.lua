local M = {}

-- CLI flags that take the next arg as value.
-- Some flags have optional args, which I have not handled
local kv_flags = {
	["-t"] = true,
	["-q"] = true,
	["--startuptime"] = true,
	["-c"] = true,
	["--cmd"] = true,
	["-S"] = true,
	["-u"] = true,
	["-i"] = true,
	["-s"] = true,
	["-w"] = true,
	["-W"] = true,
	["--listen"] = true,
}

---only allow "+" and file arguments, recognizes "--" for passing rest of args as literal files
---@param args string[]
---@return string[]
local function filter_args(args)
	local filtered = {}
	local skipnext = false
	for i, arg in ipairs(args) do
		if skipnext then
			skipnext = false
		elseif arg == "--" then
			vim.list_extend(filtered, args, i)
			break
		elseif not arg:match("^%-") then
			table.insert(filtered, arg)
		elseif kv_flags[arg] then
			skipnext = true
		end
	end
	return filtered
end

---Currently only supports files, "+cmd", and "--" for passing rest of args as literal files
---@param args string[]
---@return {commands: string[], files: string[]}
local function parse_cli_flags(args)
	local res = { commands = {}, files = {} }
	for i, arg in ipairs(args) do
		if arg == "--" then
			vim.list_extend(res.files, args, i + 1)
		elseif arg:match("^%+") then
			table.insert(res.commands, arg:sub(2))
		else
			table.insert(res.files, arg)
		end
	end
	return res
end

---@param args string[] as given by {unpack(vim.v.argv, 2)}
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
		{ "pipe", client_sock, unpack(filter_args(args)) })
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
	local cli_args = parse_cli_flags({ ... })
	local nfiles = #cli_args.files
	if nfiles == 0 then
		on_parent_done(child_chan)
		return
	elseif nfiles == 1 then
		vim.cmd.edit(unpack(cli_args.files))
		for _, cmd in ipairs(cli_args.commands) do
			vim.cmd(cmd)
		end
		vim.keymap.set('n', 'ZZ', ':w | edit #<CR>')
	else
		vim.cmd.tabnew()
		vim.cmd.args(unpack(cli_args.files))
		vim.cmd('vertical all')
		for _, cmd in ipairs(cli_args.commands) do
			vim.cmd(cmd)
		end
	end

	local group = vim.api.nvim_create_augroup("bubble_" .. child_chan, { clear = false })

	local bufs = vim.iter(cli_args.files):map(vim.fn.bufnr):totable()

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
