export GTK_IM_MODULE=ibus
export QT_IM_MODULE=ibus
export XMODIFIERS=@im=ibus
ibus-daemon -drx

[[ -f ~/.Xresources  ]] && xrdb -merge ~/.Xresources

exec awesome -c ~/.config/awesome/rc.lua 2> /home/data/tmp/log.log
