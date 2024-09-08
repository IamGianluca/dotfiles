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

--=====================================================
-- Visual Settings
--=====================================================

vim.opt.termguicolors = true

-- Display relative line numbers
vim.opt.number = true
vim.opt.relativenumber = true

-- Keep signcolumn on by default
vim.opt.signcolumn = "yes"

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
