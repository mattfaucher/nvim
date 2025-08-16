-- This file can be loaded by calling `lua require('plugins')` from your init.vim
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'

  -- Telescope
  use {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.2',
    requires = { { 'nvim-lua/plenary.nvim' } }
  }

  -- Color Schemes
  use 'navarasu/onedark.nvim'
  use "rebelot/kanagawa.nvim"
  use 'projekt0n/github-nvim-theme'

  -- TreeSitter
  use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }

  -- LSP + Completion
  use {
    'VonHeikemen/lsp-zero.nvim',
    branch = 'v2.x',
    requires = {
      { 'neovim/nvim-lspconfig' },  -- LSP support
      { 
        'williamboman/mason.nvim',  -- Mason installer
        run = function() pcall(vim.cmd, 'MasonUpdate') end
      },
      { 'williamboman/mason-lspconfig.nvim' },
      { 'hrsh7th/nvim-cmp' },       -- Completion
      { 'hrsh7th/cmp-nvim-lsp' },
      { 'L3MON4D3/LuaSnip' }
    }
  }

  -- Comment
  use {
    'numToStr/Comment.nvim',
    config = function() require('Comment').setup() end
  }

  -- Tabline
  use {
    'kdheepak/tabline.nvim',
    requires = { { 'hoob3rt/lualine.nvim', opt = true }, { 'kyazdani42/nvim-web-devicons', opt = true } },
    config = function()
      require 'tabline'.setup {
        enable = true,
        options = {
          section_separators = { '', '' },
          component_separators = { '', '' },
          max_bufferline_percent = nil,
          show_tabs_always = true,
          show_devicons = true,
          show_bufnr = false,
          show_filename_only = true,
          modified_icon = "x ",
          modified_italic = false,
          show_tabs_only = false,
        }
      }
      vim.cmd [[
        set guioptions-=e
        set sessionoptions+=tabpages,globals
      ]]
    end
  }

  -- Statusline
  use 'nvim-lualine/lualine.nvim'

  -- Floating Terminal
  use 'voldikss/vim-floaterm'

  -- Autoclose pairs
  use 'm4xshen/autoclose.nvim'

  -- Netrw extension
  use {
    'prichrd/netrw.nvim',
    config = function() require 'netrw'.setup() end
  }

  -- Nice Reference
  use {
    'wiliamks/nice-reference.nvim',
    requires = {
      'kyazdani42/nvim-web-devicons',
      {
        'rmagatti/goto-preview',
        config = function()
          require('goto-preview').setup { width = 100, height = 25 }
        end
      }
    },
    config = function()
      require 'nice-reference'.setup({
        anchor = "NW",
        relative = "cursor",
        row = 1,
        col = 0,
        border = "rounded",
        winblend = 0,
        max_width = 120,
        max_height = 10,
        auto_choose = false,
      })
    end
  }

  -- Fugitive
  use 'tpope/vim-fugitive'

  -- nvim-java plugins
  use {
    'nvim-java/nvim-java',
    requires = {
      "nvim-java/lua-async-await",
      "nvim-java/nvim-java-core",
      "nvim-java/nvim-java-test",
      "nvim-java/nvim-java-dap",
      "nvim-java/nvim-java-refactor",
    }
  }

  -- DAP + utilities
  use "MunifTanjim/nui.nvim"
  use "mfussenegger/nvim-dap"
  use "ojroques/nvim-osc52"

  -- Brazil config
  use {
    "ssh://git.amazon.com/pkg/NinjaHooks",
    branch = "mainline",
    rtp = "configuration/vim/amazon/brazil-config",
  }
end)
