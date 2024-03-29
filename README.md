This repository provides my personal configuration for several tools, including:
  * `neovim`: Using `lazy` as package manager, and with a modular configuration for the plugin installed. Plugins and LSP servers are also automatically installed installed and set up the first you start `neovim` on a fresh environment!
  * `tmux`: Using `tpm` as a package manager. Save and restore state, even after rebooting your operating system!
  * `zsh`: Using `oh-my-zsh` and the `powerlevel10k` theme. Very snappy!
  * `kitty`: Extremely fast GPU-based terminal emulator.
* Configurations for `dwm` window manager:
  * It's okay if you don't use `dwm`! The configuration will be automatically ignored.
  * Includes settings for `dwmblocks` and custom binary executable scripts to pull informations like the Linux kernel's version, the battery status, the sound settings, the current date and time, etc. 
* Copy and paste text to the system clipboard via ANSI OSC52 sequence, even when working on remote machines ― e.g., copy from/to the host system clipboard to/from remote system clipboard or even a `neovim` client.

# Installation

To download and install the dotfiles, run the following command in a terminal emulator.

```bash
git clone git@github.com:IamGianluca/dotfiles.git .dotfiles && cd .dotfiles && ./install
```

This will take care of automatically generate the necessary folders and symlinks to get you started.

A companion [repository](https://github.com/IamGianluca/ansible/tree/main) exists to install all dependencies needed to replicate my Operating System.


# TODO

- [ ] Use `$TERM` instead of hardcoding value in the `tmux`'s config.
