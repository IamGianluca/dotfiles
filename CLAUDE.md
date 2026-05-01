# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a personal dotfiles repository managed by [Dotbot](https://github.com/anishathalye/dotbot). It configures: Neovim (lazy.nvim), Tmux (tpm), Zsh (oh-my-zsh + Powerlevel10k), Ghostty terminal, direnv, and a dwm-based Linux desktop environment. The Gruvbox color scheme is used consistently across all tools.

## Common Commands

```bash
# Apply dotfiles (create symlinks, run post-install hooks)
./install

# Format Lua code (Neovim config)
make format   # runs: stylua .
```

## Adding a New Config File

1. Copy the dotfile into this repo
2. Add a symlink entry in `install.conf.yaml`
3. Run `./install`

## Architecture

### Installation (`install` + `install.conf.yaml`)

`install` is a shell script that bootstraps Dotbot (git submodule at `dotbot/`). All symlinks and directory creation are declared in `install.conf.yaml`. Dotbot runs with `relink: true` globally, and some entries use `force: true` to replace existing files/symlinks (e.g., `~/.zshrc`, `~/.config/nvim`).

### Neovim (`nvim/`)

- Entry point: `nvim/init.lua` — sets options, keymaps, and bootstraps lazy.nvim
- Plugin specs: `nvim/lua/plugins/` — one file per plugin or logical group
- Plugin manager config: `nvim/lua/config/lazy.lua`
- Locked versions: `nvim/lazy-lock.json`

Leader key is `<Space>`. Plugins are loaded lazily; first launch on a new machine auto-installs everything.

### Zsh (`zsh/`)

- `zshenv` — minimal; sets `skip_global_compinit` and sources Cargo env
- `zshrc` — oh-my-zsh with plugins: `zsh-vi-mode`, `fzf`, `zsh-autosuggestions`, `direnv`, `zsh-syntax-highlighting`
- `p10k.zsh` — generated Powerlevel10k prompt config (do not hand-edit)

### Direnv (`direnv/direnvrc`)

Defines custom `layout_uv` and `layout_poetry` functions for Python virtual environments. Projects using these layouts need a `.envrc` with e.g. `layout uv` or `layout poetry`.

### Tmux (`tmux/tmux.conf`)

Prefix is `Ctrl+A`. Uses tpm for plugins. Session persistence via tmux-resurrect + tmux-continuum (auto-restore on boot). OSC52 clipboard support via tmux-yank.

### dwm Status Bar Scripts (`bin/statusbar/`)

Shell scripts placed at `~/.local/bin/statusbar/` that feed system stats (battery, CPU temp, network, volume, etc.) to dwmblocks-async. Only relevant on Linux with dwm.

### Key Symlink Targets

| Symlink | Source |
|---|---|
| `~/.tmux.conf` | `tmux/tmux.conf` |
| `~/.zshrc` | `zsh/zshrc` |
| `~/.zshenv` | `zsh/zshenv` |
| `~/.p10k.zsh` | `zsh/p10k.zsh` |
| `~/.config/nvim` | `nvim/` |
| `~/.config/ghostty/config` | `ghostty/config` |
| `~/.config/direnv/direnvrc` | `direnv/direnvrc` |
