-- bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

vim.g.mapleader = ' '

local plugins = {

  -- whats an ide without a file explorer
  "nvim-tree/nvim-tree.lua",
  "nvim-tree/nvim-web-devicons",

  -- colorscheme
  { "catppuccin/nvim", name = "catppuccin" },

  -- default bar only looks good on linux
  "nvim-lualine/lualine.nvim",

  -- syntax highlighting apparently
  "nvim-treesitter/nvim-treesitter",
  "windwp/nvim-ts-autotag",

  -- like fzf but goofier
  {
    "nvim-telescope/telescope.nvim",
    version = "0.1.1",
    dependencies = { { "nvim-lua/plenary.nvim" } },
  },
  -- lsp stuff
  {
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "neovim/nvim-lspconfig",
  },
  -- le completion
  "hrsh7th/nvim-cmp",
  "hrsh7th/cmp-buffer",
  "hrsh7th/cmp-path",
  "hrsh7th/cmp-nvim-lsp",
  "onsails/lspkind.nvim",

  -- snippet
  "L3MON4D3/LuaSnip",
  "saadparwaiz1/cmp_luasnip",

  -- auto close to prevent carpal tunnel :
  "windwp/nvim-autopairs",

  -- git stuff lol
  "lewis6991/gitsigns.nvim",

  -- linting
  "jose-elias-alvarez/null-ls.nvim",
  "jayp0521/mason-null-ls.nvim",

  -- flex
  "andweeb/presence.nvim",

  -- color picker
  "ziontee113/color-picker.nvim",

  -- startup
  {
    'glepnir/dashboard-nvim',
    config = function()
      require('dashboard').setup {
        theme = 'hyper', --  theme is doom and hyper default is hyper
        config = {
          -- todo https://github.com/nvimdev/dashboard-nvim
          header = {
            '',
            '',
            '',
            '',
            '',
            '',
            '',
            '  █████████    █████████   █████   ████    ███████   ',
            ' ███░░░░░███  ███░░░░░███ ░░███   ███░   ███░░░░░███ ',
            '░███    ░░░  ░███    ░███  ░███  ███    ███     ░░███',
            '░░█████████  ░███████████  ░███████    ░███      ░███',
            ' ░░░░░░░░███ ░███░░░░░███  ░███░░███   ░███      ░███',
            ' ███    ░███ ░███    ░███  ░███ ░░███  ░░███     ███',
            '░░█████████  █████   █████ █████ ░░████ ░░░███████░',
            '░░░░░░░░░  ░░░░░   ░░░░░ ░░░░░   ░░░░    ░░░░░░░    ',
            '',
            '',
            '',
            '',
            '',
            '',
          }, --your header
          shortcut = {
            -- action can be a function type
            { desc = string, group = 'highlight group', key = 'shortcut key', action = 'action when you press key' },
          },
          packages = { enable = true }, -- show how many plugins neovim loaded
          -- limit how many projects list, action when you press key or enter it will run this action.
          -- action can be a functino type, e.g.
          -- action = func(path) vim.cmd('Telescope find_files cwd=' .. path) end
          project = { enable = true, limit = 8, icon = 'your icon', label = '', action = 'Telescope find_files cwd=' },
          mru = { limit = 10, icon = 'your icon', label = '', },
          footer = {}, -- footer
        }
      }
    end,
    event = 'VimEnter',
    dependencies = { { 'nvim-tree/nvim-web-devicons' } }
  }
}

require("lazy").setup(plugins, {})
