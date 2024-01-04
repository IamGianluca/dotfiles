feh --bg-scale ~/Dropbox/ubuntu-mantic-wallpaper.png &

dropbox start &

# export PATH=$PATH:$HOME/.local/bin/statusbar/ && dwmblocks 2>/tmp/dwmblocks.log &
export PATH=$PATH:$HOME/.local/bin/statusbar/ && dwmblocks &

redshift -l 41:-74 -t 5700:3600 -g 0.8 -m randr -v &
