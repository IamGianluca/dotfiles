--=====================================================
-- General Settings
--=====================================================

-- use system clipboard instead of unnamed registry
vim.opt.clipboard = "unnamedplus"

-- open new splits on the right or on the bottom of the screen
vim.opt.splitbelow = true
vim.opt.splitright = true

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

-- directories and swap files
vim.opt.backup = false
vim.opt.swapfile = false

-- search
vim.opt.incsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- line wrapping and indentation
vim.opt.smartindent = true
vim.wo.wrap = false


--=====================================================
-- Visual Settings
--=====================================================

vim.opt.termguicolors = true

-- display relative line numbers
vim.opt.nu = true
vim.opt.relativenumber = true

-- extra goodies
vim.opt.scrolloff = 8 -- try to keep at least 8 lines above and below the cursor
-- vim.opt.signcolumn = 'yes'
-- vim.opt.colorcolumn = '80'
