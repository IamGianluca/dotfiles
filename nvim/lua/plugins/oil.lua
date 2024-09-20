return {
	{
		"stevearc/oil.nvim",
		opts = {},
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("oil").setup({
				default_file_explorer = true,
				vim.keymap.set("n", "<leader>e", ":Oil<CR>", { desc = "Start oil.nvim" }),
			})
		end,
	},
}
