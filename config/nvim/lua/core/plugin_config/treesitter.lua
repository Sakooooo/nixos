require 'nvim-treesitter.configs'.setup {
  -- A list of parser names, or "all"
  -- TODO: figure this out
  ensure_installed = { "c",
    "cpp",
    "lua",
    "python",
    "nix"
  },

  -- Install parsers synchronously (only applied to 'ensure_installed)
  sync_install = false,
  auto_install = true,
  autotag = {
    enable = true,
  },
  highlight = {
    enable = true,
  },
  indent = { enable = true }
}
