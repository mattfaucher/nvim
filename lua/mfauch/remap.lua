-- Leader key
vim.g.mapleader = " "
-- Open horizontal explorer
vim.keymap.set("n", "<leader>fe", vim.cmd.Hexplore)

-- Jump with cursor in center of screen
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

-- Close current buffer
vim.keymap.set("n", "<leader>c", vim.cmd.bdelete)

-- Indent niceities
vim.keymap.set("n", ">", ">>")
vim.keymap.set("n", "<", "<<")
vim.keymap.set("v", ">", ">gv")
vim.keymap.set("v", "<", "<gv")

-- Wrap word in double/single quotes
vim.keymap.set("n", '<leader>""', 'ciw"<C-r>""') -- double quote
vim.keymap.set("n", "<leader>''", "ciw'<C-r>\"'") -- single quote
-- Same but for highlighted text
vim.keymap.set("v", '<leader>""', 'c"<C-r>""') -- double quote
vim.keymap.set("v", "<leader>''", "c'<C-r>\"'") -- single quote

-- Show references window
vim.keymap.set("n", "<leader>gr", vim.cmd.NiceReference)
