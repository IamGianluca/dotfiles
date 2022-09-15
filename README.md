# Installation

To install my dotfiles, please run the following command in your terminal.

```bash
git clone git@github.com:IamGianluca/dotfiles.git .dotfiles && cd .dotfiles && ./install
```

This cleate symlinks on the correct directories to get you started.

Please note that I've intentionally not forced the creation of missing folders as you might not need some of these dotfiles if you don't use the respective software.


# TODO:

- [ ] Add more specific luasnip snippets
- [ ] Enable extra text objects defined by `nvim-treesitter` (e.g., `iw`, `aw`)
- [ ] Automatically format codebase and sort import on save
- [ ] Add command to install `pyright` and `lua-language-server` language servers to `extra_dependencies_ubuntu.sh`
- [ ] Install rust language server
- [ ] [nvim-dap](https://github.com/mfussenegger/nvim-dap)
- [ ] [nvim-treesitter-textobjects](https://github.com/nvim-treesitter/nvim-treesitter-textobjects)
- [ ] [nvim-treesitter-textsubjects](https://github.com/rrethy/nvim-treesitter-textsubjects)
