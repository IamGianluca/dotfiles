--=====================================================
-- Lazy.nvim Settings
--=====================================================

-- bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)


return require("lazy").setup({
	-- theme
	{ "rose-pine/neovim", name = "rose-pine" },
	-- temporary disable due to issues with tmux
	-- {
	-- 	"nvim-lualine/lualine.nvim",
	-- 	dependencies = { "nvim-tree/nvim-web-devicons" },
	-- },

	-- project navigation
	{
		"nvim-telescope/telescope.nvim",
		tag = "0.1.3",
		dependencies = { "nvim-lua/plenary.nvim" }
	},

	{
		"VonHeikemen/lsp-zero.nvim",
		branch = "v1.x",
		dependencies = {
			-- LSP support
			{
				"neovim/nvim-lspconfig",
				"williamboman/mason.nvim",
				"williamboman/mason-lspconfig.nvim",
			},

			-- DAP support
			{
				"williamboman/mason.nvim",
				"mfussenegger/nvim-dap",
				"jay-babu/mason-nvim-dap.nvim",
				"rcarriga/nvim-dap-ui",
			},

			-- language server for neovim config
			{ "folke/neodev.nvim",           opts = {} },

			-- Autocompletion
			{ "hrsh7th/nvim-cmp" },
			{ "hrsh7th/cmp-nvim-lsp" },
			{ "hrsh7th/cmp-nvim-lua" },
			{ "hrsh7th/cmp-buffer" },
			{ "hrsh7th/cmp-path" },
			{ "saadparwaiz1/cmp_luasnip" },
			{ "jay-babu/mason-null-ls.nvim" },

			-- Snippets
			{ "L3MON4D3/LuaSnip" },
			{ "rafamadriz/friendly-snippets" },
		}
	},

	{
		"jose-elias-alvarez/null-ls.nvim",
		config = function()
			require("null-ls").setup()
		end,
		dependencies = { "nvim-lua/plenary.nvim" },
	},
	{
		"windwp/nvim-autopairs",
		config = function() require("nvim-autopairs").setup {} end
	},

	-- tree sitter
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate"
	},
	"nvim-treesitter/nvim-treesitter-textobjects",
	"nvim-treesitter/nvim-treesitter-context",

	-- utilities
	{
		"numToStr/Comment.nvim",
		config = function()
			require("Comment").setup()
		end
	},
	"tpope/vim-surround",
	"tpope/vim-repeat",
})
