require("lualine").setup({
	options = {
		icons_enabled = true,
		theme = "kanagawa",
	},
	sections = {
		lualine_a = {
			{
				"filename",
				path = 1,
			},
		},
	},
})
