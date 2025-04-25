ok, loader = pcall(require, "luasnip.loaders.from_vscode")
if ok then
	loader.load({
		paths = { "~/.config/nvim/snippets" },
	})
end
