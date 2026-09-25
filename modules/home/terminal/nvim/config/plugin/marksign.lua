if vim.g.loaded_marksign == 1 then
	return
end
vim.g.loaded_marksign = 1

local sign_hl_group   = "MarksignSign"

vim.cmd([[hi default link MarksignSign CurSearch]])

---@alias Bufnr integer
---@alias ExtmarkId integer
---@type table<Bufnr, table<string, ExtmarkId>>
local tracked_extmarks = {}

local ns_id            = vim.api.nvim_create_namespace("marksign")
local augroup          = vim.api.nvim_create_augroup("marksign", { clear = true })

---@param bufnr Bufnr
---@param name string
---@param line integer 1-indexed; 0 deletes the sign
local function set_extmark(bufnr, name, line)
	if not name:find("[a-zA-Z]") then
		return
	end

	if tracked_extmarks[bufnr] == nil then
		tracked_extmarks[bufnr] = {}
	end

	local extmark = tracked_extmarks[bufnr][name]
	if extmark then
		vim.api.nvim_buf_del_extmark(bufnr, ns_id, extmark)
	end

	if line == 0 then
		local old = vim.g.MARKSIGN_ANNOTATIONS
		if old and old[name] then
			old[name] = nil
			vim.g.MARKSIGN_ANNOTATIONS = old
		end
		return
	end

	local id = vim.api.nvim_buf_set_extmark(bufnr, ns_id, line - 1, 0, {
		sign_hl_group = sign_hl_group,
		sign_text = name,
		strict = false,
	})
	tracked_extmarks[bufnr][name] = id
end

local function refresh_marks(bufnr)
	tracked_extmarks[bufnr] = {}
	vim.api.nvim_buf_clear_namespace(bufnr, ns_id, 0, -1)

	for _, mark in ipairs(vim.fn.getmarklist(bufnr)) do
		if mark.pos[2] ~= 0 then
			set_extmark(bufnr, string.sub(mark.mark, 2), mark.pos[2])
		end
	end
end

vim.api.nvim_create_autocmd({ "MarkSet" }, {
	group = augroup,
	callback = function(ev)
		---@type vim.event.markset.data
		local data = ev.data
		set_extmark(ev.buf, data.name, data.line)
	end,
})

vim.api.nvim_create_autocmd({ "BufReadPost" }, {
	group = augroup,
	callback = function(ev)
		refresh_marks(ev.buf)
	end,
})

vim.api.nvim_create_autocmd({ 'BufDelete', 'BufWipeout' }, {
	group = augroup,
	callback = function(ev)
		if tracked_extmarks[ev.buf] then
			vim.api.nvim_buf_clear_namespace(ev.buf, ns_id, 0, -1)
			tracked_extmarks[ev.buf] = nil
		end
	end,
})

local function enter_callback()
	for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
		if vim.api.nvim_buf_is_loaded(bufnr) then
			refresh_marks(bufnr)
		end
	end
end
if vim.v.vim_did_enter == 1 then
	enter_callback()
else
	vim.api.nvim_create_autocmd("VimEnter", {
		callback = enter_callback,
		once = true
	})
end

vim.keymap.set("n", "dm", function()
	local char = vim.fn.getcharstr()
	if char:match("[a-zA-Z]") then
		vim.api.nvim_buf_del_mark(0, char)
	end
end, { desc = "Delete a mark" })

vim.keymap.set("n", "cm", function()
	local char = vim.fn.getcharstr()
	if char:match("[A-Z]") then
		vim.ui.input({
			prompt = "Annotation for mark " .. char .. ": ",
		}, function(anno)
			if anno == nil then
				return
			end

			-- vim.g doesn't allow mutating vim tables, we'll do it the sad way :c
			local old = vim.g.MARKSIGN_ANNOTATIONS
			if type(old) ~= "table" then
				vim.g.MARKSIGN_ANNOTATIONS = {
					[char] = anno,
				}
			else
				vim.g.MARKSIGN_ANNOTATIONS = vim.tbl_extend('force', old, {
					[char] = anno,
				})
			end
		end)
	else
		vim.notify("Marksign: only uppercase A-Z marks can be annotated", vim.log.levels.ERROR)
	end
end, { desc = "Annotate a global mark" })

vim.api.nvim_create_user_command("Marks", function()
	local qflist = {}
	for _, mark in ipairs(vim.fn.getmarklist()) do
		local name = string.match(mark.mark, "[A-Q]")
		if name and mark.file ~= "" then
			local anno = vim.g.MARKSIGN_ANNOTATIONS
				and vim.g.MARKSIGN_ANNOTATIONS[name]
				or ""
			table.insert(qflist, {
				filename = vim.fn.fnamemodify(mark.file, ":p"),
				lnum = mark.pos[2],
				col = mark.pos[3],
				text = string.format("%s %s", mark.mark, anno)
			})
		end
	end
	vim.fn.setqflist(qflist, "r")
	vim.cmd.copen()
end, { desc = "List global marks with annotations" })
