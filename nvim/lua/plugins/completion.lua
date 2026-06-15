return {
	{
		"saghen/blink.cmp",
		dependencies = { "rafamadriz/friendly-snippets", "saghen/blink.lib" },

		-- v2 has no tagged release yet, so track main rather than pinning a
		-- version. A moving branch has no prebuilt release binaries, so we
		-- build() the Rust fuzzy matcher from source (requires cargo).
		-- Once v2 is tagged, switch to version = "2.*" and build() -> download().
		branch = "main",
		build = function()
			require("blink.cmp").build():pwait()
		end,

		opts = {
			keymap = {
				["<S-Tab>"] = { "select_prev", "fallback" },
				["<Tab>"] = { "select_next", "fallback" },
				["<CR>"] = { "accept", "fallback" },
				["<Esc>"] = { "hide", "fallback" },
				["<C-b>"] = { "scroll_documentation_up", "fallback" },
				["<C-f>"] = { "scroll_documentation_down", "fallback" },
				["<C-l>"] = { "snippet_forward", "fallback" },
				["<C-h>"] = { "snippet_backward", "fallback" },
			},
			appearance = {
				nerd_font_variant = "mono",
			},
			completion = {
				list = {
					selection = { preselect = true, auto_insert = false },
				},
				accept = {
					auto_brackets = {
						-- This functionality differs from nvim-autopairs:
						-- + blink.cmp's auto_brackets: Closes brackets when
						--   accepting completions (e.g., accepting foo() adds
						--   the closing parenthesis)
						-- + nvim-autopairs: Closes brackets as you type them
						--   manually (e.g., typing ( automatically adds ))
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
				default = { "lazydev", "lsp", "path", "snippets", "buffer" },
				providers = {
					lazydev = {
						name = "LazyDev",
						module = "lazydev.integrations.blink",
						-- make lazydev completions top priority (see `:h blink.cmp`)
						score_offset = 100,
					},
					buffer = { min_keyword_length = 4 },
				},
			},
			cmdline = {
				enabled = false,
			},
			signature = {
				enabled = true,
				window = {
					border = vim.g.border_style,
				},
			},
			fuzzy = { implementation = "rust" },
		},
		opts_extend = { "sources.default" },
	},
	{
		"saghen/blink.pairs",
		dependencies = "saghen/blink.lib",
		version = "*",

		-- Pinned to a versioned release, so download() the prebuilt binary from
		-- the GitHub release (fast, no toolchain needed). download() only works
		-- on a tagged release; on a moving branch use build() instead (see blink.cmp).
		build = function()
			require("blink.pairs").download():pwait(60000)
		end,

		--- @module 'blink.pairs'
		--- @type blink.pairs.Config
		opts = {
			mappings = {
				enabled = true,
				cmdline = false,
				disabled_filetypes = {},
				pairs = {},
			},
			highlights = {
				enabled = true,
				cmdline = true,
				groups = {
					"BlinkPairsOrange",
					"BlinkPairsPurple",
					"BlinkPairsBlue",
				},
				unmatched_group = "BlinkPairsUnmatched",
				matchparen = {
					enabled = true,
					cmdline = false,
					include_surrounding = false,
					group = "BlinkPairsMatchParen",
					priority = 250,
				},
			},
			debug = false,
		},
	},
}
