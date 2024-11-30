return {
	{
		"VonHeikemen/lsp-zero.nvim",
		branch = "v4.x",
		lazy = false,
		dependencies = {
			{ "neovim/nvim-lspconfig" },
			{ "hrsh7th/nvim-cmp" },
			{ "hrsh7th/cmp-nvim-lsp" },
			{ "hrsh7th/cmp-nvim-lua" },
			{ "hrsh7th/cmp-buffer" },
			{ "hrsh7th/cmp-path" },
			{ "L3MON4D3/LuaSnip" },
			{ "saadparwaiz1/cmp_luasnip" },
			{ "williamboman/mason.nvim" },
			{ "williamboman/mason-lspconfig.nvim" },
		},

		config = function()
			local lsp_zero = require("lsp-zero")
			local lsp_attach = function(client, bufnr)
				local opts = { buffer = bufnr }

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

				-- Enable formatting on save
				lsp_zero.buffer_autoformat()
			end

			lsp_zero.extend_lspconfig({
				float_border = "rounded",
				sign_text = true,
				lsp_attach = lsp_attach,
				capabilities = require("cmp_nvim_lsp").default_capabilities(),
			})
			lsp_zero.ui({
				float_border = "rounded",
				sign_text = {
					error = "✘",
					warn = "▲",
					hint = "⚑",
					info = "»",
				},
			})

			require("mason").setup({})
			require("mason-lspconfig").setup({
				ensure_installed = { "lua_ls", "rust_analyzer", "basedpyright", "ruff", "clangd" },
				handlers = {
					lsp_zero.default_setup,
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
					lua_ls = function()
						local lua_opts = lsp_zero.nvim_lua_ls()
						require("lspconfig").lua_ls.setup(lua_opts)
					end,
					rust_analyzer = lsp_zero.noop, -- Exclude rust_analyze from autoconfiguration, required by rustaceanvim
				},
			})

			local cmp = require("cmp")
			local cmp_action = require("lsp-zero").cmp_action()

			cmp.setup({
				sources = {
					{ name = "path" },
					{ name = "nvim_lsp" },
					{ name = "nvim_lua" },
					{ name = "buffer",  keyword_length = 3 },
					{ name = "luasnip", keyword_length = 2 },
				},
				preselect = "item",
				completion = {
					completeopt = "menu,menuone,noinsert",
				},
				mapping = cmp.mapping.preset.insert({
					["<CR>"] = cmp.mapping.confirm({ select = false }),
					["<Tab>"] = cmp_action.tab_complete(),
					["<S-Tab>"] = cmp.mapping.select_prev_item(),
				}),
				window = {
					documentation = cmp.config.window.bordered(),
				},
			})

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
	{
		"windwp/nvim-autopairs",
		config = function()
			require("nvim-autopairs").setup()
			local cmp_autopairs = require("nvim-autopairs.completion.cmp")
			local cmp = require("cmp")
			cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
		end,
	},
}
