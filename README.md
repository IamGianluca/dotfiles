# Features

* Configurations for several developer tools, including:
  * `neovim`: Using `lazy` as package manager, and with a modular configuration for the plugin installed. Automatically download and setup all plugins the first time you open `neovim` on a fresh environment!
  * `tmux`: Using `tpm` as a package manager. Save and restore state, even after rebooting your operating system!
  * `zsh`: Using `oh-my-zsh` and the `powerlevel10k` theme. Very snappy!
  * `kitty`: Extremely fast GPU-based terminal emulator.
* Configurations for `DWM` window manager
  * It's okay if you don't use it! The config will be ignored.
  * Includes settings from `dwmblocks` and custom scripts to pull informations like linux kernel version, battery status, sound settings, current date and time. 
* Copy and paste from/to system clipboard with OSC52. It works also when working on remote machines ― e.g., copy from host system clipboard to remote system clipboard or even `neovim` client.

# Installation

To install my dotfiles, please run the following command in your terminal.

```bash
git clone git@github.com:IamGianluca/dotfiles.git .dotfiles && cd .dotfiles && ./install
```

This will take care of automatically generate the necessary folders and symlinks to get you started.

A companion [repository](https://github.com/IamGianluca/ansible/tree/main) exists to install all dependencies needed to replicate my OS.


# TODO

- [ ] Use `$TERM` instead of hardcoding value in `tmux` config
