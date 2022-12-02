--=====================================================
-- Packer Settings
--=====================================================

local ensure_packer = function()
	local fn = vim.fn
	local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
	if fn.empty(fn.glob(install_path)) > 0 then
		fn.system({ 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path })
		vim.cmd [[packadd packer.nvim]]
		return true
	end
	return false
end

local packer_bootstrap = ensure_packer()

return require('packer').startup(function(use)
	use 'wbthomason/packer.nvim'
	-- my plugins here
	-- theme
	use { 'ellisonleao/gruvbox.nvim' }
	use {
		'nvim-lualine/lualine.nvim',
		requires = { 'kyazdani42/nvim-web-devicons' }
	}

	-- project navigation
	use {
		'nvim-telescope/telescope.nvim', tag = '0.1.0',
		requires = { { 'nvim-lua/plenary.nvim' }, { 'kyazdani42/nvim-web-devicons' } }
	}

	-- lsp and completion
	use { 'neovim/nvim-lspconfig' }
	use { 'hrsh7th/cmp-nvim-lsp' }
	use { 'hrsh7th/cmp-buffer' }
	use { 'hrsh7th/cmp-path' }
	use { 'hrsh7th/cmp-cmdline' }
	use { 'hrsh7th/nvim-cmp' }
	use { 'saadparwaiz1/cmp_luasnip' }
	use({ 'L3MON4D3/LuaSnip', tag = 'v1.*' })
	use({
		'jose-elias-alvarez/null-ls.nvim',
		config = function()
			require('null-ls').setup()
		end,
		requires = { 'nvim-lua/plenary.nvim' },
	})
	use {
		"windwp/nvim-autopairs",
		config = function() require("nvim-autopairs").setup {} end
	}

	-- tree sitter
	use {
		'nvim-treesitter/nvim-treesitter',
		run = ':TSUpdate'
	}
	use { 'nvim-treesitter/nvim-treesitter-textobjects' }
	use { 'nvim-treesitter/nvim-treesitter-context' }

	-- utilities
	use {
		'numToStr/Comment.nvim',
		config = function()
			require('Comment').setup()
		end
	}
	use { 'tpope/vim-surround' }
	use { 'tpope/vim-repeat' }

	-- automatically set up your configuration after cloning packer.nvim
	-- put this at the end after all plugins
	if packer_bootstrap then
		require('packer').sync()
	end
end)
