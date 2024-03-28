# Set environment
xrandr --output Virtual-1 --mode 1920x1080
xwallpaper --center ~/.sys/wallpaper/*
xset r rate 300 25
xbindkeys &
unclutter -idle 1 &
setxkbmap -option caps:escape
~/.sys/statusbar/time.sh &

# Launch apps
/usr/local/apps/Discord/Discord &
dunst &
lollypop &

exec dwm
