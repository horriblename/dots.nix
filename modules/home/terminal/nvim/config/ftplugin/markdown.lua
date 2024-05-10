vim.bo.textwidth = 99
vim.bo.shiftwidth = 3 -- (auto)indent size
vim.bo.tabstop = 4    -- literal tab size
-- vim.bo.softtabstop = 4
vim.bo.expandtab = true

-- this links to tokyonight's highlight definitions for lualine
vim.cmd([[
hi @text.emphasis guifg=#e0af68 gui=italic  " rainbowcol2
hi @text.strong guifg=#9ece6a gui=bold  " rainbowcol3
hi @text.stronger guifg=#1abc9c gui=bold,italic
]])

local function conceal_as_devicon(match, _, bufnr, pred, metadata)
	if #pred == 2 then
		-- (#as_devicon! @capture)
		local capture_id = pred[2]
		local lang = vim.treesitter.get_node_text(match[capture_id], bufnr)

		local icon, _ = require("nvim-web-devicons").get_icon_by_filetype(lang, { default = true })
		metadata["conceal"] = icon
	end
end

vim.treesitter.query.add_directive("as_devicon!", conceal_as_devicon, true)
