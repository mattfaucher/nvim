-- Toggle existing float term
vim.keymap.set("n", "<C-h>", vim.cmd.FloatermToggle)
vim.keymap.set("t", "<C-h>", vim.cmd.FloatermToggle)
-- Kill floaterm
vim.keymap.set("t", "<C-k>", vim.cmd.FloatermKill)
-- Open Python shell
vim.keymap.set("n", "<leader>tfp", function()
    vim.cmd.FloatermNew "python3"
end)

-- Set float term window dimensions
vim.g.floaterm_width = 0.8
vim.g.floaterm_height = 0.6
vim.g.floaterm_position = "center"
