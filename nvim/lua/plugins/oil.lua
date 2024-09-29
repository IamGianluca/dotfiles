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
				},
				vim.keymap.set("n", "<leader>e", ":Oil<CR>", { desc = "Start oil.nvim" }),
			})
		end,
	},
}
