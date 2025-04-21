local lsp = require("lsp-zero")

lsp.preset("recommended")

-- Configure Brazil
function BrazilWorkspaceRoot()
    local working_directory = vim.fn.getcwd()
    local parent_directory = working_directory:gsub("[^/]+$", ""):gsub("[^/]+/$", "")
    return parent_directory
end

function BrazilOpenJDKLocation()
    local workspace_directory = BrazilWorkspaceRoot()
    local jdk_path = ""
    -- Determine which version of Java exists and use that
    if vim.fn.isdirectory(workspace_directory .. "env/JDK17-1.0") then
        return workspace_directory .. "env/JDK17-1.0"
    elseif vim.fn.isdirectory(workspace_directory .. "env/JDK21-1.0") then
        return workspace_directory .. "env/JDK21-1.0"
    elseif vim.fn.isdirectory(workspace_directory .. "env/JDK8-1.0") then
        return workspace_directory .. "env/JDK8-1.0"
    end

    if jdk_path == "" or jdk_path == nil then
        return "/apollo/env/EnvImprovement/jdk1.8"
    end
end

function SetBrazilJDKHome()
    vim.env.JDK_HOME = BrazilOpenJDKLocation()
end

SetBrazilJDKHome()

function Bemol()
    local bemol_dir = vim.fs.find({ '.bemol' }, { upward = true, type = 'directory' })[1]
    local ws_folders_lsp = {}
    if bemol_dir then
        local file = io.open(bemol_dir .. '/ws_root_folders', 'r')
        if file then
            for line in file:lines() do
                table.insert(ws_folders_lsp, line)
            end
            file:close()
        end
    end

    for _, line in ipairs(ws_folders_lsp) do
        vim.lsp.buf.add_workspace_folder(line)
    end
end

lsp.ensure_installed({
    'ts_ls',
    'eslint',
    'lua_ls',
    'pylsp',
    'perlnavigator',
    'gopls',
})

-- Config lsp
require('lspconfig').ts_ls.setup {
    autostart = true,
    settings = {
        typescript = {
            format = {
                indentSize = 2,
                tabSize = 2,
                convertTabsToSpaces = true
            }
        },
    }
}

require('lspconfig').eslint.setup({
    autostart = false
})

require 'lspconfig'.pylsp.setup {
    settings = {
        pylsp = {
            plugins = {
                pycodestyle = {
                    ignore = { 'W391', 'E501' },
                    maxLineLength = 100
                }
            }
        }
    }
}

require('lspconfig').jdtls.setup {
    settings = {}
}

local configs = require 'lspconfig.configs'

if not configs.barium then
	configs.barium = {
		default_config = {
			cmd = { "barium" },
			filetypes = { "brazil-config" },
			root_dir = function(fname)
				return require 'lspconfig'.util.find_git_ancestor(fname)
			end,
			settings = {},
		},
	}
end

require 'lspconfig'.barium.setup({})
vim.filetype.add({ filename = { Config = "brazil-config" } })

-- Fix undefined global 'vim'
lsp.nvim_workspace()

local cmp = require('cmp')
local cmp_select = { behavior = cmp.SelectBehavior.Select }
local cmp_mappings = lsp.defaults.cmp_mappings({
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
    ['<C-Space>'] = cmp.mapping.complete(),
})


lsp.setup_nvim_cmp({
    mapping = cmp_mappings
})

lsp.set_preferences({
    suggest_lsp_servers = false,
    sign_icons = {
        error = 'E',
        warn = 'W',
        hint = 'H',
        info = 'I'
    }
})


lsp.on_attach(function(client, bufnr)
    local opts = { buffer = bufnr, remap = false }
    vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
    vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
    vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
    vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)
    vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, opts)
    vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, opts)
    vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, opts)
    vim.keymap.set("n", "<leader>vrr", function() vim.lsp.buf.references() end, opts)
    vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, opts)
    vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
    -- Format the file & save
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

lsp.setup()

vim.diagnostic.config({
    virtual_text = true
})

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
                    virt_texts[#virt_texts + 1] = { diag.message, 'Diagnostic' .. hi[diag.severity] }
                end
                vim.api.nvim_buf_set_extmark(args.buf, ns, curline - 1, 0, {
                    virt_text = virt_texts,
                    hl_mode = 'combine'
                })
            end
        })
    end
})
