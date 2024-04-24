--=====================================================
-- Key Remappings
--=====================================================

-- Set <Space> as the leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Set keymap to open Netrw
vim.keymap.set("n", "<leader>e", vim.cmd.Ex, { desc = "Start netrw file explorer" })

-- Navigate between windows
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Move focus to the lower window" })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Move focus to the upper window" })
vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Move focus to the left window" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Move focus to the right window" })

-- Navigate between quickfix items
vim.keymap.set("n", "[q", "<cmd>cprev<CR>zz", { desc = "Previous item in quickfix list" })
vim.keymap.set("n", "]q", "<cmd>cnext<CR>zz", { desc = "Next item in quickfix list" })

-- Navigate between location list items
vim.keymap.set("n", "[l", "<cmd>lprev<CR>zz", { desc = "Previous item in location list" })
vim.keymap.set("n", "]l", "<cmd>lnext<CR>zz", { desc = "Next item in location list" })

-- When in visual mode, move up/down block of selected code
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- When using J, do not move cursor
vim.keymap.set("n", "J", "mzJ`z")

-- When using half-page jumping, keep cursor in the middle of the buffer
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

-- Keep search result in the middle of the buffer
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- When copy-pasting, do not put replaced word into registry
vim.keymap.set("x", "<leader>p", "\"_dP")

-- Clear search highlight on pressing <Esc> in Normal mode
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>', { silent = true, desc = "Clean search highlight" })
