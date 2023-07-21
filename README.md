# NVIM Setup

## Dependencies

- NVIM 0.9+
- rip grep
- Python3
- NodeJS
- [NerdFont](https://www.nerdfonts.com/)
    - [How to install](https://docs.rockylinux.org/books/nvchad/nerd_fonts/)
    - Enable this for your terminal application

### Plugin Manager

- [Packer](https://github.com/wbthomason/packer.nvim)

## Getting Started

1. [Install NVIM 0.9+](https://github.com/neovim/neovim/wiki/Installing-Neovim)
2. [Install rip grep](https://github.com/BurntSushi/ripgrep#installation)
3. Install Python3 (use your preferred method, just make sure it's in your PATH)
4. [Install NodeJS](https://nodejs.org/en/download/package-manager)
5. [Install Packer.nvim](https://github.com/wbthomason/packer.nvim#quickstart)
    - Follow along with the documentation here
6. Clone this repository (this will create the `nvim` directory for you)
```sh
cd ~/.config
git clone https://github.com/mattfaucher/nvim.git
```
7. Open NVIM by running `nvim`
8. In Normal Mode (hit ESC), type `:PackerSync` and hit enter
9. Quit out of NVIM with `:q`
10. Finally reopen NVIM and you should be all set (may need to repeat step 8 if
    you see errors upon opening)


## Installed Plugins

### These are the core plugins that make the experience
- [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim)
- [lsp-zero.nvim](https://github.com/VonHeikemen/lsp-zero.nvim)
- [treesitter.nvim](https://github.com/nvim-treesitter/nvim-treesitter)

---

### These plugins are additional but useful but not required

- [autoclose.nvim](https://github.com/m4xshen/autoclose.nvim)
- [comment.nvim](https://github.com/numToStr/Comment.nvim)
- [tabline.nvim](https://github.com/kdheepak/tabline.nvim)
- [lualine.nvim](https://github.com/nvim-lualine/lualine.nvim)
- [floaterm.nvim](https://github.com/voldikss/vim-floaterm)
- [netrw.nvim](https://github.com/prichrd/netrw.nvim)

## Basic Keybinds

The files that correspond to the configurations for the plugins all live inside
the `/after/plugins` directory. This is where you can find the docs for the
given plugin and customize it to your liking. This can be as simple as adding a
keybind for a command you want done a certain way.

Note: whenever you see `<leader>` this is a variable that you can define as a
prefix to any other keyboard shortcut/combination. In my case I defined it in
[remap.lua](https://github.com/mattfaucher/nvim/blob/master/lua/mfauch/remap.lua)
as a space. So that means I hit space + `<insert any keyboard command or
combination>`.

### Floaterm Keybinds

See [floaterm.lua](https://github.com/mattfaucher/nvim/blob/master/after/plugin/floaterm.lua)

### Telescope Keybinds

See [telescope.lua](https://github.com/mattfaucher/nvim/blob/master/after/plugin/telescope.lua)

### LSP Keybinds

See [lsp.lua](https://github.com/mattfaucher/nvim/blob/master/after/plugin/lsp.lua)

### Tabline Keybinds

See [tabline.lua](https://github.com/mattfaucher/nvim/blob/master/after/plugin/tabline.lua)

## Installing Treesitter parsers and Language Servers

Mason is used under the hood to handle Language Servers / linters / formatters

Run `:Mason` to open up the menu, alternatively install any language server by
simply running `:LspInstall <language>`.
- To find out more commands you can do `:Lsp` and hit tab to see the options.

Same deal for TreeSitter parsers:
- `:TSInstall <language>` and follow the prompts

