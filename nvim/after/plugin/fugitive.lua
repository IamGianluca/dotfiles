--=====================================================
-- vim-fugitive Settings
--=====================================================

-- when in mergediff, use `gu` to accept left side, and `gh` to accept right side
vim.keymap.set("n", "gu", "<cmd>diffget //2<CR>")
vim.keymap.set("n", "gh", "<cmd>diffget //3<CR>")
