local augroup = vim.api.nvim_create_augroup("dots_term_tweaks", { clear = true })
vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter", "WinEnter" }, {
	group = augroup,
	callback = vim.schedule_wrap(function()
		-- schedule after autocmd and double check that we are indeed going
		-- into a terminal instead of just being an in-between state when
		-- opening terminal windows
		if vim.bo.buftype:find('terminal') then
			if vim.api.nvim_win_get_cursor(0)[1] >
				vim.fn.line('$') - vim.api.nvim_win_get_height(0)
			then
				vim.cmd("startinsert")
			end
		end
	end),
})

vim.api.nvim_create_autocmd({ "TermOpen" }, {
	group = augroup,
	callback = function()
		vim.cmd("setlocal wrap nolist nonumber norelativenumber statusline=%{b:term_title}")
		vim.b.term_title = vim.b.term_title
			and string.gsub(vim.b.term_title, '.*:', '', 1)
	end,
})

vim.api.nvim_create_autocmd({ "BufLeave" }, {
	group = augroup,
	pattern = "term://*",
	callback = function()
		vim.cmd.checktime()
	end,
})
