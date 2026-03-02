---@alias term_info {buf: integer, win: integer?}
---@alias LocalID integer A unique ID for each terminal local to its tab
---@alias TabID integer

return {
	---@type table<TabID, table<LocalID, term_info>>
	tab_terms = {}
}
