--=====================================================
-- Key Remappings
--=====================================================

-- Set <Space> as the leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

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
vim.keymap.set("x", "<leader>p", '"_dP')

-- Clear search highlight on pressing <Esc> in Normal mode
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>", { silent = true, desc = "Clean search highlight" })

--=====================================================
-- General Settings
--=====================================================

-- Allow unsaved work in hidden buffers that's not displayed on our screen
vim.opt.hidden = true

-- Sync clipboard between OS and Neovim
vim.opt.clipboard = "unnamedplus"

-- Configure how new splits should be opened
vim.opt.splitbelow = true
vim.opt.splitright = true

-- Directories and swap files
vim.opt.backup = false
vim.opt.swapfile = false

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- While typing a search command, show where the pattern, as it was typed so far, matches
vim.opt.incsearch = true

-- Line wrapping and indentation
vim.opt.smartindent = true
vim.opt.wrap = false
vim.opt.shiftwidth = 4

-- Use treesitter to manage folding
vim.wo.foldmethod = "expr"
vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.wo.foldenable = false

--=====================================================
-- Visual Settings
--=====================================================

vim.opt.termguicolors = true

-- Display relative line numbers
vim.opt.number = true
vim.opt.relativenumber = true

-- Keep signcolumn on by default
vim.opt.signcolumn = "yes"

-- Highlight column 80
vim.opt.colorcolumn = "80"
vim.api.nvim_set_hl(0, "ColorColumn", { bg = "#eb6f92" })

-- Preview substitutions live, as you type!
vim.opt.inccommand = "split"

-- Show which line your cursor is on
vim.opt.cursorline = true

-- Set highlight on search
vim.opt.hlsearch = true

-- Highlight when yanking (copying) text
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})

-- Enable mouse mode, can be useful for resizing splits for example!
vim.opt.mouse = "a"

-- Extra goodies
vim.opt.scrolloff = 999 -- Keep cursor always in the middle
vim.opt.virtualedit = "block" -- Allow cursor to be positioned where there is no actual character in Visual Block mode

vim.g.border_style = "rounded" ---@type "single"|"double"|"rounded"

--=====================================================
-- Other Settings
--=====================================================

-- Prevent common typos when closing/saving
vim.cmd.abbrev("W!", "w!")
vim.cmd.abbrev("Q!", "q!")
vim.cmd.abbrev("Qall!", "qall!")
vim.cmd.abbrev("Wq", "wq")
vim.cmd.abbrev("Wa", "wa")
vim.cmd.abbrev("wQ", "wq")
vim.cmd.abbrev("WQ", "wq")
vim.cmd.abbrev("W", "w")
vim.cmd.abbrev("Q", "q")
vim.cmd.abbrev("Qa", "qa")
vim.cmd.abbrev("Qall", "qall")

--=====================================================
-- Load Plugins
--=====================================================

require("config.lazy")
