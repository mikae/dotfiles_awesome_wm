[ -f ~/.Xresources ] && xrdb -merge ~/.Xresources

exec awesome -c ~/.config/awesome/rc.lua 2> /home/data/tmp/log.log
