---@alias term_info {buf: integer, win: integer?}

---@type table<integer, table<integer, term_info>>
local tab_terms = {}

---@param buf integer
---@param y_offset integer
---@return integer
local function open_floating_win(buf, y_offset)
	local ui = vim.api.nvim_list_uis()[1]
	local width = math.floor(ui.width * 0.8)
	local height = math.floor(ui.height * 0.8)
	local col = math.floor((ui.width - width) / 2)
	local row = math.floor((ui.height - height) / 2)

	-- Open the floating window
	local win = vim.api.nvim_open_win(buf, true, {
		relative = "editor",
		width = width,
		height = height,
		col = col,
		row = row + y_offset,
		style = "minimal",
		border = "rounded",
	})
	vim.w[win].toggleterm_win_offset = y_offset

	return win
end

---@param cmd string?
---@param y_offset integer passed to open_floating_win()
---@return term_info
local function new_floating_terminal(cmd, y_offset)
	cmd = cmd or vim.o.shell

	-- Create a new (unlisted, scratch) buffer
	local buf = vim.api.nvim_create_buf(false, true)
	if buf == 0 then
		error("new_floating_terminal: could not create buffer")
	end

	-- Calculate floating window size and position
	local win = open_floating_win(buf, y_offset)

	-- Start the terminal job in that buffer
	vim.cmd.term(cmd)

	-- Enter insert mode so you can start typing in the terminal
	vim.cmd("startinsert")

	return { buf = buf, win = win }
end

---@param tab_id integer
---@param local_id integer
local function open_floating_terms(tab_id, local_id)
	if not tab_terms[tab_id] then
		tab_terms[tab_id] = {}
	end
	local tab = tab_terms[tab_id]
	local opened = false
	local y_offset = 0
	local focus_win
	for loc_id, info in pairs(tab) do
		if vim.api.nvim_buf_is_valid(info.buf) then
			info.win = open_floating_win(info.buf, y_offset)
			y_offset = y_offset + 1
			opened = true
			if loc_id == local_id then
				focus_win = info.win
			end
		else
			tab[loc_id] = nil
		end
	end

	if not opened or focus_win == nil then
		tab[local_id] = new_floating_terminal(nil, y_offset)
	elseif focus_win then
		vim.api.nvim_set_current_win(focus_win)
	end
end

---@param tab_id integer
---@param buf integer
---@return integer? local_id, term_info? info
local function find_prev_local_id(tab_id, buf)
	local prev_id, prev_info
	for local_id, info in pairs(tab_terms[tab_id] or {}) do
		if info.buf == buf then
			return prev_id, prev_info
		end
		prev_id = local_id
		prev_info = info
	end
end

---@param tab_id integer
---@param buf integer
---@return integer? local_id, term_info? info
local function find_next_local_id(tab_id, buf)
	local found = false
	for local_id, info in pairs(tab_terms[tab_id] or {}) do
		if found then
			return local_id, info
		end
		if info.buf == buf then
			found = true
		end
	end
end

local function toggleterm()
	if vim.w.toggleterm_win_offset then
		vim.cmd('fclose!')
	else
		local tabid = vim.api.nvim_get_current_tabpage()
		local local_id = vim.v.count
		open_floating_terms(tabid, local_id)
	end
end

local function focus_next()
	local offset = vim.w.toggleterm_win_offset
	if not offset then
		return
	end

	local tab_id = vim.api.nvim_get_current_tabpage()
	local local_id, info = find_next_local_id(tab_id, vim.fn.bufnr())
	if local_id and info and info.win then
		if vim.api.nvim_win_is_valid(info.win) then
			vim.api.nvim_set_current_win(info.win)
			return info.win
		end
	end
end

local function focus_prev()
	local offset = vim.w.toggleterm_win_offset
	if not offset then
		return
	end

	local tab_id = vim.api.nvim_get_current_tabpage()
	local local_id, info = find_prev_local_id(tab_id, vim.fn.bufnr())
	if local_id and info and info.win then
		if vim.api.nvim_win_is_valid(info.win) then
			vim.api.nvim_set_current_win(info.win)
			return info.win
		end
	end
end

local opts = { remap = false }
vim.keymap.set('t', '<M-m>', '<C-\\><C-n>', opts)
vim.keymap.set({ 'n', 'i', 'x', 's', 't' }, '<M-m>w', toggleterm, opts)
vim.keymap.set({ 'n', 'i', 'x', 's', 't' }, '<M-m>n', function()
	if vim.w.toggleterm_win_offset then
		local tab = tab_terms[vim.api.nvim_get_current_tabpage()]
		if not tab then return end

		local last_id = vim.iter(pairs(tab)):last()
		local offset = #vim.iter(pairs(tab))
		local info = new_floating_terminal(nil, offset + 1)
		tab[last_id + 1] = info
	end
end, opts)
vim.keymap.set({ 'n', 'i', 'x', 's', 't' }, '<M-j>', function()
	if vim.w.toggleterm_win_offset then
		focus_next()
	else
		vim.cmd.wincmd('j')
	end
end, opts)
vim.keymap.set({ 'n', 'i', 'x', 's', 't' }, '<M-k>', function()
	if vim.w.toggleterm_win_offset then
		focus_prev()
	else
		vim.cmd.wincmd('k')
	end
end, opts)
