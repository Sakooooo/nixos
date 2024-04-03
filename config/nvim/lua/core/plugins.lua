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

vim.g.mapleader = " "

local plugins = {

	-- whats an ide without a file explorer
	"nvim-tree/nvim-tree.lua",
	"nvim-tree/nvim-web-devicons",

	-- colorscheme
	-- { "bluz71/vim-moonfly-colors", name = "moonfly", lazy = false, priority = 1000 },
  "savq/melange-nvim",

	-- default bar only looks good on linux
	"nvim-lualine/lualine.nvim",

	-- syntax highlighting apparently
	"nvim-treesitter/nvim-treesitter",
	"windwp/nvim-ts-autotag",

	-- org mode
{
  'nvim-orgmode/orgmode',
  event = 'VeryLazy',
  config = function()
    -- Setup orgmode
    require('orgmode').setup({
      org_agenda_files = '~/orgfiles/**/*',
      org_default_notes_file = '~/orgfiles/refile.org',
    })

    -- NOTE: If you are using nvim-treesitter with `ensure_installed = "all"` option
    -- add `org` to ignore_install
    -- require('nvim-treesitter.configs').setup({
    --   ensure_installed = 'all',
    --   ignore_install = { 'org' },
    -- })
  end,
},

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

	-- completion
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

	-- flex
	"andweeb/presence.nvim",

	-- color picker
	"ziontee113/color-picker.nvim",

	-- startup
	{
		"glepnir/dashboard-nvim",
		config = function()
			require("dashboard").setup({
				theme = "doom", --  theme is doom and hyper default is hyper
				config = {
					-- todo https://github.com/nvimdev/dashboard-nvim
					header = {
            "",
            "",                                                                        
            "",                                                                        
            "",                                                                        
            "",                                                                        
            "",                                                                        
            "                                          iiii                          ",                                                                        
            "                                         i::::i                         ",                                                                        
            "                                          iiii                          ",                                                                        
            "                                                                        ",                                                                        
            "nnnn  nnnnnnnn vvvvvvv           vvvvvvviiiiiii    mmmmmmm    mmmmmmm   ",                                                                        
            "n:::nn::::::::nnv:::::v         v:::::v i:::::i  mm:::::::m  m:::::::mm ",                                                                        
            "n::::::::::::::nnv:::::v       v:::::v   i::::i m::::::::::mm::::::::::m",                                                                        
            "nn:::::::::::::::nv:::::v     v:::::v    i::::i m::::::::::::::::::::::m",                                                                        
            "  n:::::nnnn:::::n v:::::v   v:::::v     i::::i m:::::mmm::::::mmm:::::m",                                                                        
            "  n::::n    n::::n  v:::::v v:::::v      i::::i m::::m   m::::m   m::::m",                                                                        
            "  n::::n    n::::n   v:::::v:::::v       i::::i m::::m   m::::m   m::::m",                                                                        
            "  n::::n    n::::n    v:::::::::v        i::::i m::::m   m::::m   m::::m",                                                                        
            "  n::::n    n::::n     v:::::::v        i::::::im::::m   m::::m   m::::m",                                                                        
            "  n::::n    n::::n      v:::::v         i::::::im::::m   m::::m   m::::m",                                                                        
            "  n::::n    n::::n       v:::v          i::::::im::::m   m::::m   m::::m",                                                                        
            "  nnnnnn    nnnnnn        vvv           iiiiiiiimmmmmm   mmmmmm   mmmmmm",                                                                        
					}, --your header
					center = {
						{
							icon = " ",
							icon_hl = "Title",
							desc = "Find File           ",
							desc_hl = "String",
							keymap = "SPC SPC",
							key_hl = "Number",
							action = "lua print(2)",
						},
					},
				},
			})
		end,
		event = "VimEnter",
		dependencies = { { "nvim-tree/nvim-web-devicons" } },
	},

	-- floating terminal, useful to mimic/be better than vscode
	"voldikss/vim-floaterm",
}

require("lazy").setup(plugins, {})
