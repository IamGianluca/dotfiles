return {
	{
		"saghen/blink.cmp",
		dependencies = "rafamadriz/friendly-snippets",
		version = "v0.*",
		---@module 'blink.cmp'
		---@type blink.cmp.Config
		opts = {
			keymap = {
				["<S-Tab>"] = { "select_prev", "fallback" },
				["<Tab>"] = { "select_next", "fallback" },
				["<CR>"] = { "accept", "fallback" },
				["<C-l>"] = { "snippet_forward", "fallback" },
				["<C-h>"] = { "snippet_backward", "fallback" },
			},

			appearance = {
				use_nvim_cmp_as_default = false,
				nerd_font_variant = "mono",
			},
			completion = {
				accept = {
					auto_brackets = {
						enabled = true,
					},
				},
				menu = {

					border = vim.g.border_style,
					scrolloff = 1,
					scrollbar = false,
					draw = {
						treesitter = { "lsp" },
					},
				},
				documentation = {
					auto_show = true,
					auto_show_delay_ms = 200,
					window = {
						border = vim.g.border_style,
					},
				},
				ghost_text = {
					enabled = vim.g.ai_cmp,
				},
			},
			sources = {
				default = { "lsp", "path", "snippets", "buffer" },
			},
			signature = {
				enabled = true,
				window = {
					border = vim.g.border_style,
				},
			},
		},
		opts_extend = { "sources.default" },
	},
	{
		"neovim/nvim-lspconfig",
		dependencies = { "saghen/blink.cmp" },

		-- example using `opts` for defining servers
		-- opts = {
		-- 	servers = {
		-- 		lua_ls = {},
		-- 	},
		-- },
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
			-- for server, config in pairs(opts.servers) do
			-- 	-- passing config.capabilities to blink.cmp merges with the capabilities in your
			-- 	-- `opts[server].capabilities, if you've defined it
			-- 	config.capabilities = require("blink.cmp").get_lsp_capabilities(config.capabilities)
			-- 	lspconfig[server].setup(config)
			-- end
		end,
	},
	{
		"williamboman/mason.nvim",
		dependencies = {
			"williamboman/mason-lspconfig.nvim",
			"neovim/nvim-lspconfig",
		},
		config = function()
			require("mason").setup({})
			require("mason-lspconfig").setup({
				ensure_installed = { "lua_ls", "rust_analyzer", "basedpyright", "ruff", "clangd" },
				handlers = {
					lua_ls = function()
						require("lspconfig").lua_ls.setup({})
					end,
					basedpyright = function()
						require("lspconfig").basedpyright.setup({

							settings = {
								basedpyright = {
									analysis = {
										typeCheckingMode = "standard",
									},
								},
							},
						})
					end,
				},
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
			vim.lsp.handlers["textDocument/publishDiagnostics"] =
				vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, { virtual_text = true })

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
