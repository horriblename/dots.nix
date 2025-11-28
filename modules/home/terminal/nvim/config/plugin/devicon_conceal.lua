local function conceal_as_devicon(match, _, bufnr, pred, metadata)
	if #pred == 2 then
		-- (#as_devicon! @capture)
		local capture_id = pred[2]
		local lang = vim.treesitter.get_node_text(match[capture_id], bufnr)

		local icon, highlight = require("nvim-web-devicons").get_icon_by_filetype(lang, { default = true })
		metadata["conceal"] = icon
		metadata["highlight"] = highlight
	end
end

vim.treesitter.query.add_directive("as_devicon!", conceal_as_devicon, true)
