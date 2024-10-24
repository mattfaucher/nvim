require('osc52').setup {
    max_length = 0,
    silent = false,
    trim = false,
    tmux_passthrough = true,
}

vim.keymap.set('n', '<leader>yf', require('osc52').copy_operator, { expr = true })
vim.keymap.set('n', '<leader>yl', '<leader>yf_', { remap = true })
vim.keymap.set('v', '<leader>yf', require('osc52').copy_visual);
