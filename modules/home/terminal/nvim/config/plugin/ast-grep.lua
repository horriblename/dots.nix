-- scripts to automate creating sgconfig.yml

local template = [[
ruleDirs: []
customLanguages:
  %s:
    libraryPath: %s
    extensions: [%s]
    expandoChar: _
]]

---@param bufnr integer?
local function create_sgconfig_for_buf(bufnr)
	bufnr = bufnr or vim.fn.bufnr()
	local ft = vim.bo[bufnr].filetype
	local parser_ext = ".so"
	if vim.fn.has("mac") == 1 then
		parser_ext = ".dylib"
	elseif vim.fn.has("win64") == 1 or vim.fn.has("win32") == 1 then
		parser_ext = ".dll"
	end
	local parser_path = "parser/" .. ft .. parser_ext
	local parser = vim.api.nvim_get_runtime_file(parser_path, false)[1]
	if not parser then
		error(string.format("create_sgconfig: no parser found for filetype %s: tried %s", ft, parser_path))
	end
	local extension = vim.fn.fnamemodify(vim.fn.bufname(bufnr), ":e")
	local content = vim.split(template:format(ft, parser, extension), "\n", { plain = true })

	vim.fn.writefile(content, "sgconfig.yml")
end

vim.api.nvim_create_user_command("SgconfigGen", function()
	create_sgconfig_for_buf()
end, {})
