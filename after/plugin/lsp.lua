local lsp = require("lsp-zero").preset("recommended")

-- Configure Brazil JDK
local function BrazilWorkspaceRoot()
    local cwd = vim.fn.getcwd()
    local parent = cwd:gsub("[^/]+$", ""):gsub("[^/]+/$", "")
    return parent
end

local function BrazilOpenJDKLocation()
    local ws = BrazilWorkspaceRoot()
    if vim.fn.isdirectory(ws .. "env/JDK17-1.0") then
        return ws .. "env/JDK17-1.0"
    elseif vim.fn.isdirectory(ws .. "env/JDK21-1.0") then
        return ws .. "env/JDK21-1.0"
    elseif vim.fn.isdirectory(ws .. "env/JDK8-1.0") then
        return ws .. "env/JDK8-1.0"
    end
    return "/apollo/env/EnvImprovement/jdk1.8"
end

vim.env.JDK_HOME = BrazilOpenJDKLocation()

-- Add workspace folders from .bemol
local function Bemol()
    local bemol_dir = vim.fs.find({ '.bemol' }, { upward = true, type = 'directory' })[1]
    if bemol_dir then
        local file = io.open(bemol_dir .. '/ws_root_folders', 'r')
        if file then
            for line in file:lines() do
                vim.lsp.buf.add_workspace_folder(line)
            end
            file:close()
        end
    end
end

-- Setup Mason and LSP servers
require("mason").setup()
local mason_lspconfig = require("mason-lspconfig")
mason_lspconfig.setup({
    ensure_installed = { "gopls", "ts_ls", "lua_ls" },
    automatic_installation = true,
    handlers = {
        function(server_name)
            require('lspconfig')[server_name].setup({})
        end,
    }
})

-- Additional servers
require('lspconfig').eslint.setup({ autostart = false })
require('lspconfig').mdx_analyzer.setup({
    filetypes = { "markdown.mdx" },
})
vim.filetype.add({ extension = { mdx = "markdown.mdx" } })

-- Custom Barium LSP
local configs = require('lspconfig.configs')
if not configs.barium then
    configs.barium = {
        default_config = {
            cmd = { "barium" },
            filetypes = { "brazil-config" },
            root_dir = function(fname)
                return require('lspconfig.util').find_git_ancestor(fname)
            end,
            settings = {},
        },
    }
end
require('lspconfig').barium.setup({})
vim.filetype.add({ filename = { Config = "brazil-config" } })

-- Enable Lua runtime for nvim config
lsp.nvim_workspace()

-- Set up nvim-cmp 
local cmp = require("cmp")
lsp.setup_nvim_cmp({
    mapping = lsp.defaults.cmp_mappings({
        ['<CR>'] = cmp.mapping.confirm({ select = true }),
        ['<C-Space>'] = cmp.mapping.complete(),
    }),
})

lsp.set_preferences({
    suggest_lsp_servers = false,
    sign_icons = { error = 'E', warn = 'W', hint = 'H', info = 'I' }
})

-- Keymaps and Bemol workspace
lsp.on_attach(function(client, bufnr)
    local opts = { buffer = bufnr, remap = false }
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
    vim.keymap.set("n", "<leader>vws", vim.lsp.buf.workspace_symbol, opts)
    vim.keymap.set("n", "<leader>vd", vim.diagnostic.open_float, opts)
    vim.keymap.set("n", "[d", vim.diagnostic.goto_next, opts)
    vim.keymap.set("n", "]d", vim.diagnostic.goto_prev, opts)
    vim.keymap.set("n", "<leader>vca", vim.lsp.buf.code_action, opts)
    vim.keymap.set("n", "<leader>vrr", vim.lsp.buf.references, opts)
    vim.keymap.set("n", "<leader>vrn", vim.lsp.buf.rename, opts)
    vim.keymap.set("i", "<C-h>", vim.lsp.buf.signature_help, opts)
    vim.keymap.set("n", "<leader>fmt", function()
        vim.lsp.buf.format {
            formatting_options = {
                tabSize = 4,
                insertSpaces = true,
                trimTrailingWhitespace = true
            }
        }
        vim.cmd(':w')
    end, opts)
    Bemol()
end)

-- Diagnostics
vim.diagnostic.config({ virtual_text = true })

-- Curline diagnostics
local ns = vim.api.nvim_create_namespace('CurlineDiag')
vim.opt.updatetime = 100
vim.api.nvim_create_autocmd('LspAttach', {
    callback = function(args)
        vim.api.nvim_create_autocmd('CursorHold', {
            buffer = args.buf,
            callback = function()
                pcall(vim.api.nvim_buf_clear_namespace, args.buf, ns, 0, -1)
                local hi = { 'Error', 'Warn', 'Info', 'Hint' }
                local curline = vim.api.nvim_win_get_cursor(0)[1]
                local diagnostics = vim.diagnostic.get(args.buf, { lnum = curline - 1 })
                local virt_texts = { { (' '):rep(4) } }
                for _, diag in ipairs(diagnostics) do
                    virt_texts[#virt_texts + 1] = { diag.message, 'Diagnostic'..hi[diag.severity] }
                end
                vim.api.nvim_buf_set_extmark(args.buf, ns, curline - 1, 0, { virt_text = virt_texts, hl_mode = 'combine' })
            end
        })
    end
})

-- Finalize LSP setup
lsp.setup()

-- Configure jdtls separately
require('lspconfig').jdtls.setup({
    cmd = { 'jdtls' },
    settings = {
        java = {
            configuration = {
                runtimes = {
                    {
                        name = "JavaSE-1.8",
                        path = vim.env.JDK_HOME,
                    },
                    {
                        name = "JavaSE-17",
                        path = vim.env.JDK_HOME,
                    },
                    {
                        name = "JavaSE-21",
                        path = vim.env.JDK_HOME,
                    },
                }
            }
        }
    }
})
