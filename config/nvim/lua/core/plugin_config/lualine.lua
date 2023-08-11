require("lualine").setup({
  options = {
    icons_enabled = true,
    theme = "moonfly",
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
