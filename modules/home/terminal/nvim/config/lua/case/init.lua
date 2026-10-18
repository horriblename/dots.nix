return {
	to = setmetatable({}, {
		__index = function(_, k)
			return require("case.to")[k]
		end
	}),
	split = setmetatable({}, {
		__index = function(_, k)
			return require("case.split")[k]
		end
	})
}
