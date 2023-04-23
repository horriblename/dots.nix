M = {}

local TAB_MIN_WIDTH = 12

local fillLabel = function(title)
	if #title >= TAB_MIN_WIDTH then
		return title
	end

	local diff = TAB_MIN_WIDTH - #title
	local lfill = string.rep(' ', diff / 2)
	local rfill = string.rep(' ', diff - (diff / 2))
	return lfill .. title .. rfill
end

local tabLabel = function(tab, debug)
	local winidx = vim.fn.tabpagewinnr(tab)
	if winidx == 0 then return "?" end

	local tabinfo = vim.fn.gettabinfo(tab)
	if #tabinfo == 0 then return " ? " end

	local winid = tabinfo[1]['windows'][winidx]
	local wininfo = vim.fn.getwininfo(winid)
	if #wininfo == 0 then return "?" end

	if debug then
		print('idx ', tab)
		print('winidx ', winidx)
		print('wininfo ', wininfo)
	end

	wininfo = wininfo[1]
	if wininfo.terminal then
		return fillLabel('$ ' .. vim.fn.getbufvar(wininfo.bufnr, 'term_title'))
	else
		local title = vim.fn.bufname(wininfo.bufnr)
		if #title == 0 then
			title = '[No Name]'
		end
		return fillLabel()
	end
end


M.tabline = function(debug)
	local s = ''
	for i = 1, vim.fn.tabpagenr('$') do
		if i == vim.fn.tabpagenr() then
			s = s .. '%#TabLineSel#▌ '
		else
			s = s .. '%#TabLine#| '
		end

		-- tab page number (for mouse clicks)
		s = s .. '%' .. i .. 'T'
		s = s .. tabLabel(i, debug) .. ' '
	end

	s = s .. '%#TabLineFill#|%T'
	s = s .. '%=%#TabLine#%999XX'
	return s
end

return M
