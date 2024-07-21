vim.bo.textwidth = 99
vim.bo.shiftwidth = 3 -- (auto)indent size
vim.bo.tabstop = 4    -- literal tab size
-- vim.bo.softtabstop = 4
vim.bo.expandtab = true

vim.cmd([[
hi @text.emphasis guifg=#e0af68 gui=italic  " rainbowcol2
hi @text.strong guifg=#9ece6a gui=bold  " rainbowcol3
hi @text.stronger guifg=#1abc9c gui=bold,italic
]])
