local diagnosticIcons = {
	[vim.diagnostic.severity.ERROR] = "%#DiagnosticError# x",
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

vim.o.statusline = table.concat({
	-- Left-aligned
	"%-6{%v:lua.StatuslineMode()%} %*",
	"%{%v:lua.StatuslineFtIcon()%}",
	"  %t",
	" %h%w%m%r",
	"%{%v:lua.StatuslineGitStatus()%}",

	-- Right-aligned
	"%=",
	"%{%v:lua.StatuslineLsp()%}%*",
	"%{%v:lua.StatuslineDiagnostics()%}",
	"  %P",
	"  %l:%c",
	"  [%{&fileformat}]",
})
