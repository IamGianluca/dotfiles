"=====================================================
"" Vim-PLug core
"=====================================================
if has('vim_starting')
  set nocompatible               " Be iMproved
endif

let vimplug_exists=expand('~/.config/nvim/autoload/plug.vim')

if !filereadable(vimplug_exists)
  if !executable("curl")
    echoerr "You have to install curl or first install vim-plug yourself!"
    execute "q!"
  endif
  echo "Installing Vim-Plug..."
  echo ""
  silent !\curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  let g:not_finish_vimplug = "yes"

  autocmd VimEnter * PlugInstall
endif

call plug#begin(expand('~/.config/nvim/plugged'))


"=====================================================
"" Install plugins
"=====================================================
"" themes
Plug 'ellisonleao/gruvbox.nvim'
Plug 'nvim-lualine/lualine.nvim'
Plug 'kyazdani42/nvim-web-devicons'

"" completion
Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/nvim-cmp'
Plug 'l3mon4d3/luasnip'
Plug 'saadparwaiz1/cmp_luasnip'

"" syntax
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'nvim-treesitter/nvim-treesitter-context'

Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim', { 'tag': '0.1.0' }

Plug 'tpope/vim-surround'               " quoting/parenthesizing made simple
Plug 'tpope/vim-repeat'                 " enable repeating supported plugin maps with .
Plug 'numtostr/comment.nvim'            " comment stuff out
Plug 'ntpeters/vim-better-whitespace'   " remove whitespaces

call plug#end()


"=====================================================
"" General Settings
"=====================================================
"" open new splits on the right or on the bottom of the screen
set splitbelow
set splitright

"" prevent common typos when closing/saving
cnoreabbrev W! w!
cnoreabbrev Q! q!
cnoreabbrev Qall! qall!
cnoreabbrev Wq wq
cnoreabbrev Wa wa
cnoreabbrev wQ wq
cnoreabbrev WQ wq
cnoreabbrev W w
cnoreabbrev Q q
cnoreabbrev Qa qa
cnoreabbrev Qall qall

"" directories for swp files
set nobackup
set noswapfile

"" search
set ignorecase
set smartcase


"=====================================================
"" Import Lua Plugins Settings
"=====================================================
lua require("comment")
lua require("lsp")
lua require("keymaps")
lua require("telescope")
lua require('theme')
lua require("treesitter")


"=====================================================
"" Visual Settings
"=====================================================
"" display relative line numbers
set ruler
set relativenumber number

"" extra goodies
set nowrap
set signcolumn=auto
set colorcolumn=80


"=====================================================
"" vim-better-whitespace Settings
"=====================================================
let g:better_whitespace_enabled=1
let g:strip_whitespace_on_save=1
let g:strip_whitespace_confirm=0
