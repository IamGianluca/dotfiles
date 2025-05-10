return {
	{
		"neovim/nvim-lspconfig",
		dependencies = { "saghen/blink.cmp" },

		config = function(_, opts)
			local lspconfig = require("lspconfig")
			-- This is where you enable features that only work
			-- if there is a language server active in the file
			vim.api.nvim_create_autocmd("LspAttach", {
				desc = "LSP actions",
				callback = function(event)
					local opts = { buffer = event.buf }

					vim.keymap.set("n", "gd", function()
						vim.lsp.buf.definition()
					end, opts)
					vim.keymap.set("n", "K", function()
						vim.lsp.buf.hover()
					end, opts)
					vim.keymap.set("n", "<leader>vws", function()
						vim.lsp.buf.workspace_symbol()
					end, opts)
					vim.keymap.set("n", "<leader>vd", function()
						vim.diagnostic.open_float()
					end, opts)
					vim.keymap.set("n", "[d", function()
						vim.diagnostic.jump({ count = -1, float = true })
					end, opts)
					vim.keymap.set("n", "]d", function()
						vim.diagnostic.jump({ count = 1, float = true })
					end, opts)
					vim.keymap.set("n", "<leader>ca", function()
						vim.lsp.buf.code_action()
					end, opts)
					vim.keymap.set("n", "<leader>rr", function()
						vim.lsp.buf.references()
					end, opts)
					vim.keymap.set("n", "<leader>rn", function()
						vim.lsp.buf.rename()
					end, opts)
					vim.keymap.set("i", "<C-h>", function()
						vim.lsp.buf.signature_help()
					end, opts)
				end,
			})
		end,
	},
	{
		"mason-org/mason.nvim",
		dependencies = {
			"williamboman/mason-lspconfig.nvim",
			"neovim/nvim-lspconfig",
		},
		config = function()
			require("mason").setup({})
			require("mason-lspconfig").setup({
				automatic_enable = true,
				ensure_installed = { "lua_ls", "rust_analyzer", "basedpyright", "ruff", "clangd" },
			})

			-- Diagnostics
			vim.diagnostic.config({
				virtual_text = true,
				severity_sort = true,
				float = {
					style = "minimal",
					border = "rounded",
					source = true,
					header = "",
					prefix = "",
				},
			})

			-- Spelling
			local o = vim.opt
			o.spelllang = { "en" }
			o.spell = true

			-- Show inline diagnostics
			vim.diagnostic.config({
				virtual_text = true,
				signs = true,
				underline = true,
				update_in_insert = false,
				severity_sort = true,
			})

			-- Show inlay hints
			vim.lsp.inlay_hint.enable(true, { 0 })
		end,
	},
	{
		"mrcjkb/rustaceanvim",
		version = "^5",
		lazy = false, -- this plugin is already lazy
	},
	{ "folke/neodev.nvim", opts = {} },
	{
		"stevearc/conform.nvim",
		config = function()
			require("conform").setup({
				formatters_by_ft = {
					lua = { "stylua" },
					-- ruff_fix to sort imports, ruff_format to format the rest of the file
					python = { "ruff_fix", "ruff_format" },
					rust = { "rust_analyzer" },
				},
				format_on_save = {
					timeout_ms = 500,
					lsp_fallback = true,
				},
			})
		end,
	},
}
