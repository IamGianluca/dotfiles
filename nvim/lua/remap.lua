--=====================================================
-- Key Remappings
--=====================================================

vim.keymap.set("n", "<Space>", "<Nop>")
vim.g.mapleader = " "

vim.keymap.set("n", "<leader>e", vim.cmd.Ex, { desc = "Start netrw file explorer" })

vim.keymap.set("", "<C-j>", "<C-w>j", { desc = "Move to lower pane" })
vim.keymap.set("", "<C-k>", "<C-w>k", { desc = "Move to higher pane" })
vim.keymap.set("", "<C-h>", "<C-w>h", { desc = "Move to left pane" })
vim.keymap.set("", "<C-l>", "<C-w>l", { desc = "Move to right pane" })

vim.keymap.set("n", "<Esc>", ":noh<CR><Esc>", { silent = true, desc = "Clean search highlight" })

-- when in visual mode, move up/down block of selected code
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")
