# AGENTS.md

This file provides guidance to AI coding agents when working with code in this repository.

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

- `zshenv` — minimal; sources Cargo env
- `zshrc` — oh-my-zsh with plugins: `zsh-vi-mode`, `fzf`, `zsh-autosuggestions`, `direnv`, `zsh-syntax-highlighting`
- `p10k.zsh` — generated Powerlevel10k prompt config (do not hand-edit)

### Claude Code (`claude/`)

- `CLAUDE.md` — global instructions applied to every project
- `settings.json` — model, theme, and permission defaults

Both are symlinked into `~/.claude/`, which also holds untracked machine-local state (sessions, history, plugins). Only these two files are tracked, plus the shared skills below.

### Shared Agent Skills (`skills/`)

Skills used by both Claude Code and pi: `software-design`, `refactoring`, `testing`, `agent-evals`. Single source of truth — edit here, both agents see it.

`~/.agents/` is the shared cross-agent location; each agent's own directory holds only agent-specific config. The two agents support this unevenly, so the linking differs:

- **pi** reads `~/.agents/skills/` natively ([docs](https://pi.dev/docs/latest/skills)), alongside `~/.pi/agent/skills/`. No per-agent link needed.
- **Claude Code** does *not* read `~/.agents/`; it only reads `~/.claude/skills/` ([docs](https://code.claude.com/docs/en/skills)). It does support a skill entry being a symlink elsewhere, so each skill is linked into `~/.claude/skills/` as a bridge.

Both link targets point at this repo directly rather than chaining through `~/.agents/`, keeping one level of indirection.

`~/.agents/skills/` also holds eval skills installed by `npx skills` from [ai-evals-course/evals-skills](https://github.com/ai-evals-course/evals-skills), tracked in its own `~/.agents/.skill-lock.json` and symlinked onward into `~/.claude/skills/`. Those are not tracked here — manage them with `npx skills`.

Every `SKILL.md` needs both `name` and `description` frontmatter; pi and Claude Code both require them.

### pi (`pi/agent/`)

Agent-specific config: `AGENTS.md` (global instructions), `settings.json`, and TypeScript extensions. `AGENTS.md` stays pi-only — Claude Code reads `CLAUDE.md`, not `AGENTS.md`, and pi's much smaller system prompt makes always-on design guidance worth its context cost there in a way it isn't for Claude.

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
| `~/.gitconfig` | `git/gitconfig` |
| `~/.config/nvim` | `nvim/` |
| `~/.config/ghostty/config` | `ghostty/config` |
| `~/.config/direnv/direnvrc` | `direnv/direnvrc` |
| `~/.claude/CLAUDE.md` | `claude/CLAUDE.md` |
| `~/.claude/settings.json` | `claude/settings.json` |
| `~/.claude/skills/<skill>` | `skills/<skill>/` (one link per skill) |
| `~/.agents/skills/<skill>` | `skills/<skill>/` (one link per skill) |
