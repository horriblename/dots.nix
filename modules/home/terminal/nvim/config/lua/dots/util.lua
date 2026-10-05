local M = {}

---Makes two keymaps for directional keymaps.
---
---Note that vim.keycode("<CR>") returns "\r\n" which is effectively hitting
---enter twice so use "\n" instead
---@param back_key string? LHS of the back keymap, e.g. "<leader>xp"
---@param back string RHS of the back keymap, e.g. ":GoPrev\n" (see note on <CR>)
---@param forward_key string? LHS of the forward keymap, e.g. "<leader>xn"
---@param forward string RHS of the next keymap, e.g. ":GoNext\n" (see note on <CR>)
function M.mkDirectionalKeymap(back_key, back, forward_key, forward)
	back = vim.keycode(back)
	forward = vim.keycode(forward)
	if back_key then
		vim.keymap.set("n", back_key, function()
			vim.fn.setreg("p", back)
			vim.fn.setreg("n", forward)

			return "@p"
		end, { expr = true })
	end
	if forward_key then
		vim.keymap.set("n", forward_key, function()
			vim.fn.setreg("p", back)
			vim.fn.setreg("n", forward)

			return "@n"
		end, { expr = true })
	end
end

return M
