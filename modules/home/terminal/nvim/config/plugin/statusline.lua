local diagnosticIcons = {
	[vim.diagnostic.severity.ERROR] = "%#DiagnosticError# 🞩",
	[vim.diagnostic.severity.WARN] = "%#DiagnosticWarn# !",
	[vim.diagnostic.severity.INFO] = "%#DiagnosticInfo# i",
	[vim.diagnostic.severity.HINT] = "%#DiagnosticInfo# ?",
}
function _G.StatuslineDiagnostics()
	local diag = vim.diagnostic.count(0)
	local s = ""
	local typ = vim.diagnostic.severity.ERROR
	s = s .. (diag[typ] and diagnosticIcons[typ] .. diag[typ] or "")

	typ = vim.diagnostic.severity.WARN
	s = s .. (diag[typ] and diagnosticIcons[typ] .. diag[typ] or "")

	typ = vim.diagnostic.severity.INFO
	s = s .. (diag[typ] and diagnosticIcons[typ] .. diag[typ] or "")

	typ = vim.diagnostic.severity.HINT
	s = s .. (diag[typ] and diagnosticIcons[typ] .. diag[typ] or "")

	return s ~= "" and s .. " %0*" or ""
end

---@param path string[]
---@return string
local function highlighted_label(path)
	local len = #path
	if len == 1 then
		return path[1]
	end
	local dir = vim.fs.joinpath(unpack(path, 1, len - 1))
	local basename = path[len]
	return string.format("%%#Comment#%s/%%*%s", dir, basename)
end

---Table storing the shortest paths disambiguating all open windows in this
---tab
---@type table<string, string>
local filename_labels = {}

function _G.Labels()
	vim.print(filename_labels)
end

---@param paths string[] full paths to compute minimal path
---@return table<string, {dir: string, basename: string}> -- map of full path -> shortened path
local function compute_suffixes(paths)
	---@type table<string, {suffix: string[], full: string[], expand: boolean?}>
	local labels = {}
	for _, p in ipairs(paths) do
		labels[p] = {
			suffix = { vim.fn.fnamemodify(p, ":t") },
			full = vim.split(p, "/")
		}
	end

	local unique = false
	local depth = 1

	while not unique do
		unique = true
		local seen = {}

		for _, data in pairs(labels) do
			local label = vim.fs.joinpath(unpack(data.suffix))
			if seen[label] then
				unique = false
				seen[label].expand = true
				data.expand = true
			else
				seen[label] = data
			end
		end

		if not unique then
			for _, data in pairs(labels) do
				if data.expand then
					local full = data.full
					local suffix = data.suffix
					local parent_index = #full - depth
					if parent_index >= 1 then
						table.insert(suffix, 1, full[parent_index])
					end
					data.suffix = suffix
					data.expand = nil
				end
			end
			depth = depth + 1
		end
	end

	local out = {}
	for p, data in pairs(labels) do
		out[p] = highlighted_label(data.suffix)
	end
	return out
end

function _G.StatuslineFileName()
	local bufname = vim.api.nvim_buf_get_name(0)
	return filename_labels[bufname] or bufname
end

function _G.StatuslineGitStatus()
	local git_info = vim.b.gitsigns_status_dict
	if not git_info or git_info.head == "" then
		return ""
	end
	local added = git_info.added and ("%#GitSignsAdd# +" .. git_info.added) or ""
	local changed = git_info.changed and ("%#GitSignsChange# ~" .. git_info.changed) or ""
	local removed = git_info.removed and ("%#GitSignsDelete# -" .. git_info.removed) or ""
	if git_info.added == 0 then
		added = ""
	end
	if git_info.changed == 0 then
		changed = ""
	end
	if git_info.removed == 0 then
		removed = ""
	end
	return table.concat({
		" ",
		added,
		changed,
		removed,
		" %*",
	}, "")
end

local modes = {
	["n"] = "%#Normal# NORMAL",
	["no"] = "%#Normal# NORMAL",
	["v"] = "%#Visual# VISUAL",
	["V"] = "%#Visual# V-LINE",
	[""] = "%#Visual# V-BLOCK",
	["s"] = "%#Visual# SELECT",
	["S"] = "%#Visual# S-LINE",
	[""] = "%#Visual# S-BLOCK",
	["i"] = "INSERT",
	["ic"] = "INSERT",
	["R"] = "%#ErrorMsg# REPLACE",
	["Rv"] = "%#ErrorMsg# V-REPLACE",
	["c"] = "%#@command# COMMAND",
	["cv"] = "%#@command# VIM EX",
	["ce"] = "%#@command# EX",
	["r"] = "PROMPT",
	["rm"] = "MOAR",
	["r?"] = "CONFIRM",
	["!"] = "SHELL",
	["t"] = "TERMINAL",
}

function _G.StatuslineMode()
	return modes[vim.fn.mode()]
end

function _G.StatuslineFtIcon()
	local ok, devicons = pcall(require, "nvim-web-devicons")
	if not ok then
		return ""
	end

	local icon, highlight = devicons.get_icon(vim.fn.expand("%:t"), vim.bo.filetype, { default = true })

	if highlight then
		highlight = string.format("%%#%s#", highlight)
	end
	return string.format(" %s%s%%*", highlight, icon)
end

local lsp_skipset = { copilot = true }
function _G.StatuslineLsp()
	local attached = vim.lsp.get_clients({ bufnr = vim.fn.bufnr() })

	if vim.tbl_isempty(attached) then
		return ""
	end

	local main_lsp = vim.iter(attached):find(function(client)
		return not lsp_skipset[client.name]
	end) or attached[1]

	local count = #attached > 1 and "%#Comment#+" .. (#attached - 1) or ""
	return " " .. main_lsp.name .. count
end

function _G.Tabline()
	local s = require('string.buffer').new()
	local tab_ids = vim.api.nvim_list_tabpages()
	for i = 1, vim.fn.tabpagenr('$') do
		local win = vim.api.nvim_tabpage_get_win(tab_ids[i])
		local cwd = vim.fn.fnamemodify(
			vim.fn.getcwd(win, i),
			[[:p:~:s#\/$##:gs#\([^/]\)[^/]*\/#\1\/#]])

		-- tab click target
		s:put("%", i, "T")

		-- tab highlight and tabnr
		if i == vim.fn.tabpagenr() then
			s:put("%#TabLineSel# ")
		else
			s:put("%#Special# ", i, "%#TabLine#")
		end

		-- label
		s:put(cwd, " ")
	end

	-- filler
	s:put("%#TabLineFill#%T")

	-- right-align close button
	if vim.fn.tabpagenr('$') > 1 then
		s:put("%=%#ErrorMsg#%999X X")
	end

	return s:get()
end

-- autocmds
local function syncShortFileNames()
	local wins = vim.api.nvim_tabpage_list_wins(0)
	local bufnames = vim.iter(wins):map(function(win)
		local buf = vim.api.nvim_win_get_buf(win)
		if vim.bo[buf].buftype ~= "" then return nil end
		return vim.api.nvim_buf_get_name(buf)
	end):totable()
	filename_labels = compute_suffixes(bufnames)
end

local augroup = vim.api.nvim_create_augroup("dots_statusline", { clear = true })
vim.api.nvim_create_autocmd({ "BufWinEnter", "TabEnter" }, {
	group = augroup,
	callback = syncShortFileNames,
})
if vim.v.vim_did_enter == 1 then
	syncShortFileNames()
else
	vim.api.nvim_create_autocmd("VimEnter", {
		callback = syncShortFileNames,
		once = true
	})
end

vim.o.statusline = table.concat({
	-- Left-aligned
	"%-6{%v:lua.StatuslineMode()%} %*",
	"%{%v:lua.StatuslineFtIcon()%}",
	" %{%v:lua.StatuslineFileName()%}",
	" %h%w%m%r",
	"%<",
	"%{%v:lua.StatuslineGitStatus()%}",

	-- Right-aligned
	"%=",
	"%{%v:lua.StatuslineLsp()%}%*",
	"%{%v:lua.StatuslineDiagnostics()%}",
	"  %P",
	"  %l:%c",
	"  [%{&fileformat}]",
})

vim.o.tabline = "%!v:lua.Tabline()"
