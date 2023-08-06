local M = {}

---@class NixTSConfig
---@field use_channels boolean (always on for now) Whether to use nix channels

---@type NixTSConfig
M.options = nil


---@param options table
---@return NixTSConfig
local function with_defaults(options)
	-- TODO: warn unknown flags
	return {
		use_channels = true -- options.use_channels or true,
	}
end

---@param argLead string
---@return string
local function grammarCompletion(argLead, _, _)
	local grammars = require("nix-treesitter.lazy").listAvailableGrammars()
	if argLead == '' then
		return grammars
	end
	return vim.fn.matchfuzzy(grammars, argLead)
end

---@param options NixTSConfig
function M.setup(options)
	M.options = with_defaults(options or {})

	vim.api.nvim_create_user_command(
		"NixAddTSGrammar",
		function(cmd_args)
			require("nix-treesitter.lazy").includeGrammar(cmd_args.args[1])
		end,
		{
			complete = grammarCompletion,
			nargs = 1,
		}
	)
end

return M
