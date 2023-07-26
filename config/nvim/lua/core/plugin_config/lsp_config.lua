require("cmp")
require("mason").setup()
require("mason-lspconfig").setup({
--	ensure_installed = { "lua_ls", "omnisharp", "pyright", "clangd" },
})
local mason_null_ls = require("mason-null-ls")

-- vscode
local on_attach = function(client, bufnr)
	vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, {})
	vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, {})

	vim.keymap.set("n", "gd", vim.lsp.buf.definition, {})
	vim.keymap.set("n", "gi", vim.lsp.buf.implementation, {})
	vim.keymap.set("n", "gr", require("telescope.builtin").lsp_references, {})
	vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
end

-- enable autocomplete
local capabilities = require("cmp_nvim_lsp").default_capabilities()

--format thing
mason_null_ls.setup({
--	ensure_installed = {
--		"stylua",
--		"prettier",
	},
})

-- funny lsp config stuff
require('lspconfig').rnix.setup({
  on_attach = on_attach,
  capabilities = capabilities,
})


require("lspconfig").lua_ls.setup({
	on_attach = on_attach,
	capabilities = capabilities,
})

require("lspconfig").omnisharp.setup({
	on_attach = on_attach,
	capabilities = capabilities,
})

require("lspconfig").cmake.setup({
	on_attach = on_attach,
	capabilities = capabilities,
})

require("lspconfig").clangd.setup({
	on_attach = on_attach,
	capabilities = capabilities,
})

require("lspconfig").tsserver.setup({
	on_attach = on_attach,
	capabilities = capabilities,
})

require("lspconfig").html.setup({
	on_attach = on_attach,
	capabilities = capabilities,
})

require("lspconfig").eslint.setup({
	on_attach = function(client, bufnr)
		vim.api.nvim_create_autocmd("BufWritePre", {
			buffer = bufnr,
			command = "EslintFixAll",
		})
	end,
})

require("lspconfig").pyright.setup({
	on_attach = on_attach,
	capabilities = capabilities,
})

require("lspconfig").cssls.setup({
	on_attach = on_attach,
	capabilities = capabilities,
})

require('lspconfig')['hls'].setup{
  filetypes = { 'haskell', 'lhaskell', 'cabal' },
}
