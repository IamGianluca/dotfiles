# Installation

To install my dotfiles, please run the following command in your terminal.

```bash
git clone git@github.com:IamGianluca/dotfiles.git .dotfiles && cd .dotfiles && ./install
```

This will generate the necessary folders and symlinks to get you started.

Please note that I've intentionally not forced the creation of missing folders as you might not need some of these dotfiles if you don't use the respective software.


# TODO:

- [ ] Add more specific luasnip snippets
- [ ] Enable extra text objects defined by `nvim-treesitter` (i.e., `af`, `if`, `ac`, `ic`)
- [ ] Install language servers with `mason.nvim`
- [ ] [nvim-dap](https://github.com/mfussenegger/nvim-dap)
- [ ] [nvim-treesitter-textobjects](https://github.com/nvim-treesitter/nvim-treesitter-textobjects)
- [ ] [nvim-treesitter-textsubjects](https://github.com/rrethy/nvim-treesitter-textsubjects)
