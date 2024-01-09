--=====================================================
-- General Settings
--=====================================================

-- allow unsaved work in hidden buffers that's not displayed on our screen
vim.opt.hidden = true

-- synchronizes the system clipboard with neovim's clipboard
vim.opt.clipboard = "unnamedplus"

-- open new splits on the right or on the bottom of the screen
vim.opt.splitbelow = true
vim.opt.splitright = true

-- directories and swap files
vim.opt.backup = false
vim.opt.swapfile = false

-- search
vim.opt.incsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- line wrapping and indentation
vim.opt.smartindent = true
vim.opt.wrap = false
vim.opt.shiftwidth = 4


--=====================================================
-- Visual Settings
--=====================================================

vim.opt.termguicolors = true

-- display relative line numbers
vim.opt.number = true
vim.opt.relativenumber = true

-- extra goodies
vim.opt.scrolloff = 999       -- keep cursor always in the middle
vim.opt.virtualedit = "block" -- allow cursor to be positioned where there is no actual character in Visual Block mode


--=====================================================
-- Other Settings
--=====================================================

-- prevent common typos when closing/saving
vim.cmd.abbrev('W!', 'w!')
vim.cmd.abbrev('Q!', 'q!')
vim.cmd.abbrev('Qall!', 'qall!')
vim.cmd.abbrev('Wq', 'wq')
vim.cmd.abbrev('Wa', 'wa')
vim.cmd.abbrev('wQ', 'wq')
vim.cmd.abbrev('WQ', 'wq')
vim.cmd.abbrev('W', 'w')
vim.cmd.abbrev('Q', 'q')
vim.cmd.abbrev('Qa', 'qa')
vim.cmd.abbrev('Qall', 'qall')
