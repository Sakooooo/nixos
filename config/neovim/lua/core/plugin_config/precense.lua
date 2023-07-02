require("presence").setup({
	-- options
	auto_update = true,
	neovim_image_text = "mama mia",
	main_image = "neovim",
	client_id = "793271441293967371",
	log_level = nil,
	debounce_timeout = 10,
	enable_line_number = false,
	blacklist = {},
	file_assets = {},
	show_time = true,

	-- the text
	editing_text = "editing %s",
	file_explorer_text = "file explorer",
	git_commit_text = "git comit",
	plugin_manager_text = "adding bloatware",
	reading_text = "reading %s",
	workspace_text = "workspace: %s",
	line_number_text = "line %s out of %s",
})
