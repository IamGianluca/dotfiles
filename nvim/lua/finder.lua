-- "=====================================================
-- "" Telescope Settings
-- "=====================================================
vim.keymap.set("n", "<leader>ff", ":lua require('telescope.builtin').find_files()<cr>")
vim.keymap.set("n", "<leader>fg", ":lua require('telescope.builtin').live_grep()<cr>")
vim.keymap.set("n", "<leader>fb", ":lua require('telescope.builtin').buffers()<cr>")
vim.keymap.set("n", "<leader>fh", ":lua require('telescope.builtin').help_tags()<cr>")


require 'telescope'.setup {}
local actions = require 'telescope.actions'

require 'telescope'.setup {
	defaults = {
		mappings = {
			i = {
				["<C-j>"] = actions.move_selection_next,
				["<C-k>"] = actions.move_selection_previous,
			},
		},
	},
}
