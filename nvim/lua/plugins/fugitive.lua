return {
	"tpope/vim-fugitive",
	config = function()
		-- Keymap for easier resolving merge conflicts in :G(v)diffsplit
		vim.keymap.set("n", "gu", "<cmd>diffget //2<CR>") -- Get changes from target branch
		vim.keymap.set("n", "gh", "<cmd>diffget //3<CR>") -- Get changes from merge branch
	end,
}
