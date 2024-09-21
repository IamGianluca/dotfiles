return {
	"David-Kunz/gen.nvim",
	config = function()
		require("gen").setup({
			model = "llama3.1",
			display_mode = "split",
			show_prompt = true,
		})
	end,
}
