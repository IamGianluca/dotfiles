--=====================================================
-- vim-fugitive Settings
--=====================================================

-- keymap for easier resolving merge conflicts in :G(v)diffsplit
vim.keymap.set("n", "gu", "<cmd>diffget //2<CR>") -- get changes from target branch
vim.keymap.set("n", "gh", "<cmd>diffget //3<CR>") -- get changes from merge branch
