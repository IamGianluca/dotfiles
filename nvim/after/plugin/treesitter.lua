--=====================================================
-- treesitter Settings
--=====================================================

require("nvim-treesitter.configs").setup({
	ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "python", "rust" },
	auto_install = true,
	highlight = {
		enable = true,
	},
	indent = {
		enable = true,
	},
	textobjects = {
		select = {
			enable = true,
			lookahead = true,
			keymaps = {
				["aa"] = { query = "@parameter.outer", desc = "Select outer part of a parameter region" },
				["ia"] = { query = "@parameter.inner", desc = "Select inner part of a parameter region" },

				["af"] = { query = "@function.outer", desc = "Select outer part of a function region" },
				["if"] = { query = "@function.inner", desc = "Select inner part of a function region" },

				["ac"] = { query = "@class.outer", desc = "Select the outer part of a class region" },
				["ic"] = { query = "@class.inner", desc = "Select inner part of a class region" },
			},
			include_surrounding_whitespace = true,
		},
		move = {
			enable = true,
			set_jumps = true,
			goto_next_start = {
				["]a"] = { query = "@parameter.inner", desc = "Next parameter start" },
				["]m"] = { query = "@function.outer", desc = "Next function start" },
				["]]"] = { query = "@class.outer", desc = "Next class start" },
			},
			goto_next_end = {
				["]M"] = { query = "@function.outer", desc = "Next function end" },
				["]["] = { query = "@class.outer", desc = "Nexc class end" },
			},
			goto_previous_start = {
				["[a"] = { query = "@parameter.inner", desc = "Previous parameter start" },
				["[m"] = { query = "@function.outer", desc = "Previous function start" },
				["[]"] = { query = "@class.outer", desc = "Previous class start" },
			},
			goto_previous_end = {
				["[M"] = { query = "@function.outer", desc = "Previous function end" },
				["[["] = { query = "@class.outer", desc = "Previous class end" },
			},
		},
	},
	incremental_selection = {
		enable = true,
		keymaps = {
			init_selection = "<Leader>ss", -- Selection start
			node_incremental = "<Leader>si", -- Selection increase
			scope_incremental = "<Leader>sc", -- Selection scope
			node_decremental = "<Leader>sd", -- Selection decrease
		},
	},
})

--=====================================================
-- treesitter-context Settings
--=====================================================

require("treesitter-context").setup({
	enable = true, -- Enable this plugin (Can be enabled/disabled later via commands)
	max_lines = 0, -- How many lines the window should span. Values <= 0 mean no limit.
	trim_scope = "outer", -- Which context lines to discard if `max_lines` is exceeded. Choices: 'inner', 'outer'
	patterns = { -- Match patterns for TS nodes. These get wrapped to match at word boundaries.
		-- For all filetypes
		-- Note that setting an entry here replaces all other patterns for this entry.
		-- By setting the 'default' entry below, you can control which nodes you want to
		-- appear in the context window.
		default = {
			"class",
			"function",
			"method",
			-- 'for', -- These won't appear in the context
			-- 'while',
			-- 'if',
			-- 'switch',
			-- 'case',
		},
		-- Example for a specific filetype.
		-- If a pattern is missing, *open a PR* so everyone can benefit.
		--   rust = {
		--       'impl_item',
		--   },
	},
	exact_patterns = {
		-- Example for a specific filetype with Lua patterns
		-- Treat patterns.rust as a Lua pattern (i.e "^impl_item$" will
		-- exactly match "impl_item" only)
		-- rust = true,
	},

	-- [!] The options below are exposed but shouldn't require your attention,
	--     you can safely ignore them.

	zindex = 20, -- The Z-index of the context window
	mode = "cursor", -- Line used to calculate context. Choices: 'cursor', 'topline'
	separator = nil, -- Separator between context and content. Should be a single character string, like '-'.
})
