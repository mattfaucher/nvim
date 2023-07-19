-- Leader key
vim.g.mapleader = " "
-- Back to explorer
vim.keymap.set("n", "<leader>fe", vim.cmd.Ex)

-- Jump with cursor in center of screen
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

-- Close current buffer
vim.keymap.set("n", "<leader>c", vim.cmd.bdelete)
