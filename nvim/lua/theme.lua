-- "=====================================================
-- "" Gruvbox Theme Settings
-- "=====================================================
vim.opt.termguicolors = true
vim.o.background = "dark" -- or "light" for light mode
require("gruvbox").setup({
  undercurl = true,
  underline = true,
  bold = true,
  italic = true,
  strikethrough = true,
  invert_selection = false,
  invert_signs = false,
  invert_tabline = false,
  invert_intend_guides = false,
  inverse = true, -- invert background for search, diffs, statuslines and errors
  contrast = "hard", -- can be "hard", "soft" or empty string
  overrides = {},
})
vim.cmd("colorscheme gruvbox")


-- "=====================================================
-- "" Lualine Settings
-- "=====================================================
require('lualine').setup({})