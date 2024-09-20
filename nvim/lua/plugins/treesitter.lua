return {
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		dependencies = {
			"nvim-treesitter/nvim-treesitter-textobjects",
		},
		config = function()
			require("nvim-treesitter.configs").setup({
				ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "python", "rust" },
				sync_install = false,
				auto_install = true,
				highlight = {
					enable = true,
					additional_vim_regex_highlighting = false,
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
							["]["] = { query = "@class.outer", desc = "Next class end" },
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
					swap = {
						enable = true,
						swap_next = {
							["<leader>a"] = "@parameter.inner",
						},
						swap_previous = {
							["<leader>A"] = "@parameter.inner",
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
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter-context",
		config = function()
			require("treesitter-context").setup({
				enable = true,
				max_lines = 0,
				trim_scope = "outer",
				patterns = {
					default = {
						"class",
						"function",
						"method",
					},
				},
				exact_patterns = {
					-- rust = true,
				},
				zindex = 20,
				mode = "cursor",
				separator = nil,
			})
		end,
	},
}
