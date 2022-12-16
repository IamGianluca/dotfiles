--=====================================================
-- nvim-cmp Settings
--=====================================================
local lsp = require('lsp-zero')

lsp.preset('recommended')

lsp.on_attach(function(client, bufnr)
	local opts = { buffer = bufnr, remap = false }

	vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
	vim.keymap.set("n", "gD", function() vim.lsp.buf.declaration() end, opts)
	vim.keymap.set("n", "gr", function() vim.lsp.buf.references() end, opts)
	vim.keymap.set("n", "gi", function() vim.lsp.buf.implementation() end, opts)
	vim.keymap.set("i", "<C-k>", function() vim.lsp.buf.signature_help() end, opts)
	vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
	vim.keymap.set("n", "<leader>rn", function() vim.lsp.buf.rename() end, opts)
	vim.keymap.set("n", "<leader>ca", function() vim.lsp.buf.code_action() end, opts)
	vim.keymap.set("n", "<leader>f", function() vim.lsp.buf.format() end, opts)

	vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
	vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)
	vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, opts)
	vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, opts)
end)

lsp.setup()


--=====================================================
-- null-ls Settings
--=====================================================

-- needed to format and sort imports in Python since PyRight doesn't offer
-- those functionalities
require("null-ls").setup({
	sources = {
		require("null-ls").builtins.formatting.black,
		require("null-ls").builtins.formatting.usort,
	},
})


--=====================================================
-- nvim-autopairs Settings
--=====================================================

require('nvim-autopairs').setup()


--=====================================================
-- General Settings
--=====================================================

-- format on save for every language
vim.cmd [[autocmd BufWritePre * lua vim.lsp.buf.format()]]

-- spelling
local o = vim.opt
o.spelllang = { 'en' }
o.spell = true
