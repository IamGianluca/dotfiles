Personal dotfiles managed with [Dotbot](https://github.com/anishathalye/dotbot). Covers editor, terminal, shell, and desktop environment.

## What's included

| Tool | Notes |
|---|---|
| `neovim` | `lazy.nvim` plugin manager, modular config under `nvim/lua/plugins/`. Plugins and LSP servers auto-install on first launch. |
| `tmux` | `tpm` plugin manager. Session persistence via tmux-resurrect + tmux-continuum. OSC52 clipboard support. |
| `zsh` | `oh-my-zsh` with Powerlevel10k theme. Plugins: `zsh-vi-mode`, `fzf`, `zsh-autosuggestions`, `direnv`, `zsh-syntax-highlighting`. |
| `ghostty` | GPU-accelerated terminal emulator. |
| `jj` | Jujutsu version control system. |
| `direnv` | Custom `layout_uv` and `layout_poetry` helpers for Python virtualenvs. |
| `dwm` | Window manager config, `dwmblocks-async` status bar scripts (battery, CPU temp, network, volume, etc.). Safe to ignore if not using dwm. |

## Installation

```bash
git clone git@github.com:IamGianluca/dotfiles.git ~/.dotfiles && cd ~/.dotfiles && ./install
```

`./install` creates all symlinks and directories declared in `install.conf.yaml`. Safe to re-run — existing symlinks are relinked, not duplicated.

A companion [Ansible repository](https://github.com/IamGianluca/ansible/tree/main) installs all system dependencies.

## Adding a new dotfile

```bash
mv ~/.config/tool/config ~/.dotfiles/tool/config   # move into repo
# add entry to install.conf.yaml
./install                                           # create symlink
```
