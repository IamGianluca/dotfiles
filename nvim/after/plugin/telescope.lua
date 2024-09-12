--=====================================================
-- Telescope Settings
--=====================================================

-- The lsp_dynamic_workspace_symbols picker, for some reasons, does not use
-- automatically fzf sorting. We need to manually set it:
-- https://github.com/nvim-telescope/telescope.nvim/issues/2104#issuecomment-1223790155
local fzf_opts = {
	fuzzy = true,                -- false will only do exact matching
	override_generic_sorter = true, -- override the generic sorter
	override_file_sorter = true, -- override the file sorter
	case_mode = "smart_case",    -- or "ignore_case" or "respect_case"
	-- the default case_mode is "smart_case"
}

local telescope = require("telescope")
local builtin = require("telescope.builtin")
vim.keymap.set("n", "gr", builtin.lsp_references, { desc = "[G]o to [R]eference" })
vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "[F]ind [F]iles" })
vim.keymap.set("n", "<leader>fs", function()
	builtin.lsp_dynamic_workspace_symbols({
		sorter = telescope.extensions.fzf.native_fzf_sorter(fzf_opts)
	})
end, { desc = "[F]ind [S]ymbols" })
vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "[F]ind [G]rep" })
vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "[F]ind [B]uffers" })
vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "[F]ind [H]elp" })
vim.keymap.set("n", "<leader>fk", builtin.keymaps, { desc = "[F]ind [K]eymaps" })

require("telescope").load_extension("fzf")
