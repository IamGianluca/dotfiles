--=====================================================
-- Load Plugins
--=====================================================

require('keymaps')
require('plugins')
require('treesitter')
require('theme')
require('finder')
require('lsp')
require('comment')


--=====================================================
-- General Settings
--=====================================================

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
vim.opt.ignorecase = true
vim.opt.smartcase = true


--=====================================================
-- Visual Settings
--=====================================================

-- display relative line numbers
vim.opt.ruler = true
vim.opt.relativenumber = true
vim.wo.number = true

-- extra goodies
vim.wo.wrap = false -- don't wrap lines
vim.opt.signcolumn = 'auto'
vim.opt.colorcolumn = '80'
vim.opt.cmdheight = 0
