return {
	{
		"nvim-treesitter/nvim-treesitter",
		branch = "main",
		build = ":TSUpdate",
	},
	{
		"MeanderingProgrammer/treesitter-modules.nvim",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		opts = {
			ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "python", "rust" },
			ignore_install = {},
			modules = {},
			sync_install = false,
			auto_install = true,
			highlight = {
				enable = true,
				additional_vim_regex_highlighting = false,
			},
			indent = {
				enable = true,
			},
			fold = {
				enable = true,
			},
		},
	},
	{
		"nvim-treesitter/nvim-treesitter-textobjects",
		branch = "main",
		config = function()
			require("nvim-treesitter-textobjects").setup({

				select = {
					enable = true,
					lookahead = true,
					include_surrounding_whitespace = true,
				},
				move = {
					enable = true,
					set_jumps = true,
				},
				swap = {
					enable = true,
				},
			})

			-- Set keymaps for textobjects selection
			local select = require("nvim-treesitter-textobjects.select").select_textobject

			vim.keymap.set({ "x", "o" }, "aa", function()
				select("@parameter.outer", "textobjects")
			end, { desc = "Select outer part of a parameter region" })
			vim.keymap.set({ "x", "o" }, "ia", function()
				select("@parameter.inner", "textobjects")
			end, { desc = "Select inner part of a parameter region" })
			vim.keymap.set({ "x", "o" }, "af", function()
				select("@function.outer", "textobjects")
			end, { desc = "Select outer part of a function region" })
			vim.keymap.set({ "x", "o" }, "if", function()
				select("@function.inner", "textobjects")
			end, { desc = "Select inner part of a function region" })
			vim.keymap.set({ "x", "o" }, "ac", function()
				select("@class.outer", "textobjects")
			end, { desc = "Select the outer part of a class region" })
			vim.keymap.set({ "x", "o" }, "ic", function()
				select("@class.inner", "textobjects")
			end, { desc = "Select inner part of a class region" })

			-- Set keymaps for textobjects swap
			vim.keymap.set("n", "<leader>a", function()
				require("nvim-treesitter-textobjects.swap").swap_next("@parameter.inner")
			end, { desc = "Swap current argument with next one" })
			vim.keymap.set("n", "<leader>A", function()
				require("nvim-treesitter-textobjects.swap").swap_previous("@parameter.inner")
			end, { desc = "Swap current argument with previous one" })

			-- Set keymaps for textobjects move
			-- Note: [c and ]c are default mappings to navigate diff changes. I'm overriding them
			local prev_start = require("nvim-treesitter-textobjects.move").goto_previous_start
			vim.keymap.set({ "n", "x", "o" }, "[a", function()
				prev_start("@parameter.inner", "textobjects")
			end, { desc = "Previous parameter start" })
			vim.keymap.set({ "n", "x", "o" }, "[m", function()
				prev_start("@function.outer", "textobjects")
			end, { desc = "Previous function start" })
			vim.keymap.set({ "n", "x", "o" }, "[c", function()
				prev_start("@class.outer", "textobjects")
			end, { desc = "Previous class start" })

			local next_start = require("nvim-treesitter-textobjects.move").goto_next_start
			vim.keymap.set({ "n", "x", "o" }, "]a", function()
				next_start("@parameter.inner", "textobjects")
			end, { desc = "Next parameter start" })
			vim.keymap.set({ "n", "x", "o" }, "]m", function()
				next_start("@function.outer", "textobjects")
			end, { desc = "Next function start" })
			vim.keymap.set({ "n", "x", "o" }, "]c", function()
				next_start("@class.outer", "textobjects")
			end, { desc = "Next class start" })

			local prev_end = require("nvim-treesitter-textobjects.move").goto_previous_end
			vim.keymap.set({ "n", "x", "o" }, "[M", function()
				prev_end("@function.outer", "textobjects")
			end, { desc = "Previous function end" })
			vim.keymap.set({ "n", "x", "o" }, "[C", function()
				prev_end("@class.outer", "textobjects")
			end, { desc = "Previous class end" })

			local next_end = require("nvim-treesitter-textobjects.move").goto_next_end
			vim.keymap.set({ "n", "x", "o" }, "]M", function()
				next_end("@function.outer", "textobjects")
			end, { desc = "Next function end" })
			vim.keymap.set({ "n", "x", "o" }, "]C", function()
				next_end("@class.outer", "textobjects")
			end, { desc = "Next class end" })
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter-context",
		opts = {
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
			zindex = 20,
			mode = "cursor",
			separator = nil,
		},
	},
	{
		-- Better incremental selection compared to the one provided by nvim-treesitter / nvim-treesitter-modules
		"sustech-data/wildfire.nvim",
		event = "VeryLazy",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		opts = {
			keymaps = {
				init_selection = "<CR>",
				node_incremental = "<CR>",
				node_decremental = "<BS>",
			},
		},
	},
}
