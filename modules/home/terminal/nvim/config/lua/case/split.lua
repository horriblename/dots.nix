local M = {}

---A splitter function that works reasonably well on various case conventions
---@param text string
---@return fun():string
function M.auto(text)
	local iter = string.gmatch(text, '[A-Z]*[a-z0-9]*')

	return function()
		local word = iter()
		while word == '' do word = iter() end
		return word
	end
end

return M
