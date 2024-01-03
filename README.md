# Installation

To install my dotfiles, please run the following command in your terminal.

```bash
git clone git@github.com:IamGianluca/dotfiles.git .dotfiles && cd .dotfiles && ./install
```

This will generate the necessary folders and symlinks to get you started.

Please note that I've intentionally not forced the creation of missing folders as you might not need some of these dotfiles if you don't use the respective software.

Additionally, run the following command to add the custom binary executables used in `dwmblocks`.

```bash
sudo cp bin/* /usr/local/bin/
```
