[ -f ~/.Xresources ] && xrdb -merge ~/.Xresources

exec awesome -c ~/.config/awesome/rc.lua