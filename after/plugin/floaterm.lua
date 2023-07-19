-- Create a new floatterm & Kill the window
vim.keymap.set("n", "<leader>tf", vim.cmd.FloatermNew)
vim.keymap.set("t", "<C-l>", vim.cmd.FloatermKill)
vim.keymap.set("n", "<leader>ftl", vim.cmd.FloatermLast)
-- Open Python shell
vim.keymap.set("n", "<leader>tfp", function()
    vim.cmd.FloatermNew "python3"
end)

-- Set float term window
vim.g.floaterm_width = 0.8
vim.g.floaterm_height = 0.6
vim.g.floaterm_position = "center"
