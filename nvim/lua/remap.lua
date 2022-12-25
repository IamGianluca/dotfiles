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

-- when using J, do not move cursor
vim.keymap.set("n", "J", "mzJ`z")

-- when using half-page jumping, keep cursor in the middle of the buffer
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

-- keep search result in the middle of the buffer
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- when copy-pasting, do not put replaced word into registry
vim.keymap.set("x", "<leader>p", "\"_dP")

-- copy to system clipboard
vim.keymap.set("n", "<leader>y", "\"+y")
vim.keymap.set("v", "<leader>y", "\"+y")
vim.keymap.set("n", "<leader>Y", "\"+Y")
