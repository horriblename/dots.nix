-- Fixes behavior of windows with winfixheight and winfixwidth changing size
-- after closing a window

---@param target integer
---@param layout vim.fn.winlayout.branch
---@return vim.fn.winlayout.branch?, integer index
local function find_parent_layout(target, layout)
	for i, l in ipairs(layout[2]) do
		if l[1] == "leaf" then
			return l[2] == target and layout or nil, i
		end

		---@cast l vim.fn.winlayout.branch
		local found = find_parent_layout(target, l)
		if found ~= nil then
			return found, i
		end
	end
	return nil, 0
end

---checks if any nested child sticking to the specified side has the
---given option enabled
---@param opt string
---@param node vim.fn.winlayout.branch|vim.fn.winlayout.leaf
---@param side side
---@return integer[] win_ids that need resizing
local function leaves_with_option_enabled(opt, node, side)
	if node[1] == "leaf" then
		local leaf = node[2]
		---@cast leaf integer
		local o = vim.wo[leaf][opt]
		-- local o = node[3] or false
		assert(type(o) == "boolean")
		if o then
			return { leaf }
		end
	elseif node[1] == "col" then
		---@cast node vim.fn.winlayout.branch
		local children = node[2]
		if side == "up" then
			return leaves_with_option_enabled(opt, children[1], side)
		elseif side == "down" then
			return leaves_with_option_enabled(opt, children[#children], side)
		else -- left or right => all children span horizontal edge
			return vim.iter(children):map(function(child)
				return leaves_with_option_enabled(opt, child, side)
			end):flatten():totable()
		end
	elseif node[1] == "row" then
		---@cast node vim.fn.winlayout.branch
		local children = node[2]
		if side == "left" then
			return leaves_with_option_enabled(opt, children[1], side)
		elseif side == "right" then
			return leaves_with_option_enabled(opt, children[#children], side)
		else
			return vim.iter(children):map(function(child)
				return leaves_with_option_enabled(opt, child, side)
			end):flatten():totable()
		end
	end
	return {}
end

---@alias direction "vertical"|"horizontal"
---@alias side "up"|"right"|"down"|"left"

---@type table<integer, {width: integer?, height: integer?}>
local needs_resize = {}

local function on_win_closed(ev)
	local closed_winid = tonumber(ev.match)
	vim.notify("[fixwfh] closed win: " .. closed_winid, vim.log.levels.TRACE)
	if not closed_winid then
		vim.notify("[fixwfh] invalid closed_winid", vim.log.levels.TRACE)
		return
	end

	local tabnr = vim.fn.win_id2tabwin(closed_winid)[1]
	if tabnr == 0 then
		vim.notify("[fixwfh] tab does not exist", vim.log.levels.TRACE)
		return
	end

	local layout = vim.fn.winlayout(tabnr)
	if #layout == 0 or layout[1] == "leaf" then
		vim.notify("[fixwfh] top-level is a leaf", vim.log.levels.TRACE)
		return
	end

	---@cast layout vim.fn.winlayout.branch

	---@type direction
	local direction
	local sibling
	local side ---@type side

	do
		local parent, closed_index = find_parent_layout(closed_winid, layout)
		if parent == nil then
			vim.notify("[fixwfh] closed winid not found in layout", vim.log.levels.TRACE)
			return
		end

		assert(parent[2][closed_index][2] == closed_winid)
		if parent[2][closed_index - 1] then
			sibling = parent[2][closed_index - 1]
			side = parent[1] == "row" and "right" or "down"
		elseif parent[2][closed_index + 1] then
			sibling = parent[2][closed_index + 1]
			side = parent[1] == "row" and "left" or "up"
		else
			vim.notify("[fixwfh] no sibling found", vim.log.levels.TRACE)
			return
		end

		direction = parent[1] == "row" and "horizontal" or "vertical"
	end

	-- look for windows in the sibling row/column with winfixheight/width
	local option = direction == "vertical" and "winfixheight" or "winfixwidth"
	local descendants ---@type integer[]
	if sibling[1] == "leaf" then
		vim.notify("[fixwfh] sibling is leaf", vim.log.levels.TRACE)
		return
	else
		local winids = leaves_with_option_enabled(option, sibling, side)
		if #winids == 0 then
			vim.notify("[fixwfh] no descendant of sibling has " .. option, vim.log.levels.TRACE)
			return
		end
		descendants = winids
	end

	for _, win in ipairs(descendants) do
		-- schedule a resize after window is removed from layout
		needs_resize[win] = {
			height = direction == "vertical"
				and vim.api.nvim_win_get_height(win)
				or nil,
			width = direction == "horizontal"
				and vim.api.nvim_win_get_width(win)
				or nil,
		}
	end

	vim.notify("[fixwfh] scheduling resize" .. vim.inspect(needs_resize), vim.log.levels.TRACE)
end

local group = vim.api.nvim_create_augroup("fix_winfixheight", { clear = true })
vim.api.nvim_create_autocmd("WinClosed", {
	group = group,
	callback = function(ev)
		local ok, err = pcall(on_win_closed, ev)
		if not ok and type(err) == "string" then
			vim.notify_once(err, vim.log.levels.ERROR)
		end
	end,
})

vim.api.nvim_create_autocmd("WinResized", {
	group = group,
	callback = function()
		for winid, info in pairs(needs_resize) do
			pcall(vim.api.nvim_win_call,
				winid,
				function()
					if info.width then
						vim.cmd.resize({ info.width, mods = { vertical = true } })
					end
					if info.height then
						vim.cmd.resize(info.width)
					end
				end
			)
			vim.notify_once(
				string.format("[fixwfh] restored win size: (%s, %s)", info.width, info.height),
				vim.log.levels.TRACE
			)
		end
		needs_resize = {}
	end
})
