# Installation

To install my dotfiles, please run the following command in your terminal.

```bash
git clone git@github.com:IamGianluca/dotfiles.git .dotfiles && cd .dotfiles && ./install
```

This will take care of automatically generate the necessary folders and symlinks to get you started.

A companion [repository](https://github.com/IamGianluca/ansible/tree/main) exists to install all dependencies needed to replicate my OS.


# TODO

- [ ] Fix bug where `dmenu` freezes after changing `xrandr` settings (switching from `xps` to `desktop` setting)
- [ ] Copy/yank to host system clipboard does not work in Docker (e.g., yank some text inside a Docker container, then paste in host system)
- [ ] Use `$TERM` instead of hardcoding value in `tmux` config
- [ ] Switch from `powerline-shell` to [`powerlevel10k`](https://github.com/romkatv/powerlevel10k)
