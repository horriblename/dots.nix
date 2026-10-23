return {
	name = "snipls",
	---@param dispatchers vim.lsp.rpc.Dispatchers
	---@return vim.lsp.rpc.PublicClient
	cmd = function(dispatchers)
		local snipls = require("snipls.snippet")
		local pkg_jsons = vim.api.nvim_get_runtime_file("package.json", true)
		---@type string[]
		local all_snippets = { isIncomplete = false, items = {} }
		for _, pkg_json in ipairs(pkg_jsons) do
			local paths = snipls.parse_pkg(pkg_json, vim.bo.filetype)
			for _, snips_path in ipairs(paths) do
				local snips = snipls.read_file(snips_path)
				local lsp_snip = snipls.process_snippets(snips, 'Snip')
				if lsp_snip and lsp_snip.items then
					for _, snippet_item in ipairs(lsp_snip.items) do
						table.insert(all_snippets.items, snippet_item)
					end
				end
			end
		end


		return snipls.new_server(all_snippets)(dispatchers)
	end,
	root_markers = { ".git/", ".anchor" },
	---@param client vim.lsp.Client
	---@param config vim.lsp.ClientConfig
	reuse_client = function(client, config)
		local buf = next(client.attached_buffers)
		_G.root_was = config.root_dir
		return client.config.root_dir == config.root_dir
			and buf
			and vim.bo[buf].filetype == vim.bo.filetype
	end,
	on_init = function(_)
		vim.notify('Snippet LSP server initialized', vim.log.levels.INFO)
	end,
}
