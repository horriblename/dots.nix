-- project management
local config = {
	buftype_blacklist = { 'acwrite', 'terminal', 'nofile', 'quickfix', 'prompt', 'help' },
}

local repoHome = vim.fs.normalize("~/repo")
function _G.FindProjectRoot(win_id)
	local buf = vim.api.nvim_win_get_buf(win_id)

	local lsp_root = vim.api.nvim_win_call(win_id, vim.lsp.buf.list_workspace_folders)[0]
	if lsp_root then
		return lsp_root
	end

	-- look for the .git marker, stop at ~/repo/*/ and /nix/store/*/
	local bufpath = vim.api.nvim_buf_get_name(buf)
	local fallback = bufpath
	for dir in vim.fs.parents(bufpath) do
		if vim.uv.fs_stat(vim.fs.joinpath(dir, ".git")) then
			return dir
		end
		if dir == repoHome or dir == "/nix/store" then
			break
		end
		fallback = dir
	end

	local marker_root = vim.fs.root(buf, { "flake.nix" })
	return marker_root or fallback
end

function _G.RefreshProjectRoot(win_id)
	win_id = win_id or vim.fn.win_getid()
	local root = _G.FindProjectRoot(win_id)
	if root then
		vim.api.nvim_win_call(win_id, function()
			vim.cmd("silent tcd " .. root)
			vim.cmd.lcd(root)
		end)
	end
end

local group = vim.api.nvim_create_augroup("dots_project_management", { clear = true })
vim.api.nvim_create_autocmd({ "LspAttach", "BufWinEnter" }, {
	group = group,
	callback = function(_)
		if vim.list_contains(config.buftype_blacklist or {}, vim.bo.buftype) then
			return
		end
		pcall(_G.RefreshProjectRoot, vim.fn.win_getid())
	end
})
