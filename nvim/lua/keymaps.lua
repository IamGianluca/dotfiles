-- =====================================================
-- Key Remappings
-- =====================================================
vim.keymap.set("n", "<Space>", "<Nop>")
vim.g.mapleader = " "

vim.keymap.set("", "<C-j>", "<C-w>j", { desc = "Move to lower pane" })
vim.keymap.set("", "<C-k>", "<C-w>k", { desc = "Move to higher pane" })
vim.keymap.set("", "<C-h>", "<C-w>h", { desc = "Move to left pane" })
vim.keymap.set("", "<C-l>", "<C-w>l", { desc = "Move to right pane" })

vim.keymap.set("n", "<Esc>", ":noh<CR><Esc>", { silent = true, desc = "clean search highlight" })
