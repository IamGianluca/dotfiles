return {
	{
		"stevearc/oil.nvim",
		opts = {},
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("oil").setup({
				default_file_explorer = true,
				keymaps = {
					["<C-h>"] = false,
					["<C-l>"] = false,
					["q"] = "actions.close",
					["<Esc>"] = "actions.close",
				},
				vim.keymap.set("n", "<leader>e", ":Oil --float<CR>", { desc = "Start oil.nvim" }),
				float = {
					border = "rounded",
				},
				progress = {
					border = "rounded",
				},
				confirmation = {
					border = "rounded",
				},
			})
		end,
	},
}
