--=====================================================
-- Key Remappings
--=====================================================

-- remap leader key
vim.keymap.set("n", "<Space>", "<Nop>")
vim.g.mapleader = " "

vim.keymap.set("n", "<leader>e", vim.cmd.Ex, { desc = "Start netrw file explorer" })

-- navigate between windows
vim.keymap.set("", "<C-j>", "<C-w>j", { desc = "Move to lower window" })
vim.keymap.set("", "<C-k>", "<C-w>k", { desc = "Move to higher window" })
vim.keymap.set("", "<C-h>", "<C-w>h", { desc = "Move to left window" })
vim.keymap.set("", "<C-l>", "<C-w>l", { desc = "Move to right window" })

-- navigate between quickfix items
vim.keymap.set("n", "[q", "<cmd>cprev<CR>zz", { desc = "Previous item in quickfix list" })
vim.keymap.set("n", "]q", "<cmd>cnext<CR>zz", { desc = "Next item in quickfix list" })

-- navigate between location list items
vim.keymap.set("n", "[l", "<cmd>lprev<CR>zz", { desc = "Previous item in location list" })
vim.keymap.set("n", "]l", "<cmd>lnext<CR>zz", { desc = "Next item in location list" })

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

vim.keymap.set("n", "<Esc>", ":noh<CR><Esc>", { silent = true, desc = "Clean search highlight" })
