-- project management
local config = {
	buftype_blacklist = { 'acwrite', 'terminal', 'nofile', 'quickfix', 'prompt', 'help' },
}

local repoHome = vim.fs.normalize("~/repo")

-- NOTE: we take win_id instead of buf_id cuz
-- vim.lsp.buf.list_workspace_folders doesn't accept it
--
---@param win_id integer
---@return string path, string kind kind is only for debugging
function _G.FindProjectRoot(win_id)
	local buf = vim.api.nvim_win_get_buf(win_id)

	local lsp_root = vim.api.nvim_win_call(win_id, vim.lsp.buf.list_workspace_folders)[1]
	if lsp_root then
		return lsp_root, "lsp"
	end

	-- look for the .git marker, stop at ~/repo/*/ and /nix/store/*/
	local bufpath = vim.api.nvim_buf_get_name(buf)
	local found_fallback = false
	local fallback = bufpath
	for dir in vim.fs.parents(bufpath) do
		if vim.uv.fs_stat(vim.fs.joinpath(dir, ".git")) then
			return dir, "git"
		end
		if dir == repoHome or dir == "/nix/store" then
			found_fallback = true
			break
		end
		fallback = dir
	end

	local marker_root = vim.fs.root(buf, { "flake.nix" })
	if marker_root then return marker_root, "flake.nix" end
	if found_fallback then return fallback, "fallback" end

	return vim.fs.dirname(bufpath), "buf_directory"
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
