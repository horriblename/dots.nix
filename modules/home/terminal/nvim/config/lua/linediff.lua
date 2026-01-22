-- region_mirror/init.lua

local M = {}

M.ns = vim.api.nvim_create_namespace("region_mirror")

-- All active regions
M.regions = {}
M.next_region_id = 1

-- One augroup per source buffer
M.buffer_groups = {}

-- -------------------------
-- Utilities
-- -------------------------

---@param name string
---@return integer
local function create_scratch(name)
	local buf = vim.api.nvim_create_buf(false, true)
	vim.api.nvim_buf_set_name(buf, name)
	vim.bo[buf].buftype = "nofile"
	vim.bo[buf].bufhidden = "wipe"
	vim.bo[buf].swapfile = false

	vim.cmd("vsplit")
	vim.api.nvim_win_set_buf(0, buf)
	vim.wo.diff = true

	return buf
end

local function get_mark_range(src_buf, mark_id)
	local marks = vim.api.nvim_buf_get_extmarks(
		src_buf,
		M.ns,
		mark_id,
		mark_id,
		{ details = true }
	)

	if #marks == 0 then
		return nil
	end

	local _, start_row, _, details = unpack(marks[1])
	return start_row, details.end_row
end

-- -------------------------
-- Core update logic
-- -------------------------

function M.update_region(region_id)
	local r = M.regions[region_id]
	if not r then
		return
	end

	if not (
			vim.api.nvim_buf_is_valid(r.src_buf)
			and vim.api.nvim_buf_is_valid(r.scratch_buf)
		) then
		M.regions[region_id] = nil
		return
	end

	local start_row, end_row = get_mark_range(r.src_buf, r.mark_id)
	if not start_row then
		M.regions[region_id] = nil
		return
	end

	local lines = vim.api.nvim_buf_get_lines(
		r.src_buf,
		start_row,
		end_row + 1,
		false
	)

	vim.api.nvim_buf_set_lines(r.scratch_buf, 0, -1, false, lines)
end

---@param buf any
---@return boolean found -- whether this buffer has any live region (regardless of whether they were changed)
function M.update_buffer(buf)
	local found = false
	for id, region in pairs(M.regions) do
		if region.src_buf == buf then
			found = true
			M.update_region(id)
		end
	end
	return found
end

-- -------------------------
-- Public API
-- -------------------------

---@param from integer line number, zero indexed
---@param to integer line number, zero indexed
function M.mark_region(from, to)
	local src_buf = vim.api.nvim_get_current_buf()
	local start_row, end_row = from, to
	if not start_row and not end_row then
		start_row = vim.fn.line('.') - 1
		end_row = start_row
	elseif not end_row then
		end_row = start_row
	end
	local end_col = math.max(0, #vim.fn.getline(end_row + 1) - 1)

	local region_id = M.next_region_id
	M.next_region_id = M.next_region_id + 1

	local scratch_buf = create_scratch(
		string.format("[Region Mirror %d]", region_id)
	)

	local mark_id = vim.api.nvim_buf_set_extmark(
		src_buf,
		M.ns,
		start_row,
		0,
		{
			end_row = end_row,
			end_col = end_col,
			right_gravity = false,
			end_right_gravity = true,
		}
	)

	M.regions[region_id] = {
		src_buf = src_buf,
		mark_id = mark_id,
		scratch_buf = scratch_buf,
	}

	local scratch_augroup = vim.api.nvim_create_augroup(
		"LinediffWipe_" .. scratch_buf,
		{ clear = true }
	)
	vim.api.nvim_create_autocmd('BufWipeout', {
		buffer = scratch_buf,
		group = scratch_augroup,
		once = true,
		callback = function()
			vim.api.nvim_buf_del_extmark(src_buf, M.ns, mark_id)
			vim.api.nvim_del_augroup_by_id(scratch_augroup)
		end
	})

	-- Set up autocommand once per source buffer
	if not M.buffer_groups[src_buf] then
		local group = vim.api.nvim_create_augroup(
			"RegionMirrorBuf" .. src_buf,
			{ clear = true }
		)

		vim.api.nvim_create_autocmd(
			{ "TextChanged", "TextChangedI" },
			{
				group = group,
				buffer = src_buf,
				callback = function()
					if not M.update_buffer(src_buf) then
						vim.api.nvim_del_augroup_by_id(group)
					end
				end,
			}
		)

		M.buffer_groups[src_buf] = group
	end

	-- Initial sync
	M.update_region(region_id)
end

function M.operatorfunc(_)
	local from = vim.fn.line("'[") - 1
	local to = vim.fn.line("']") - 1
	M.mark_region(from, to)
end

return M
