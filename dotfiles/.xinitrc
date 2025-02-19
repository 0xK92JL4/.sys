# Set environment
xrandr --output DP-1 --mode 1920x1080 --rate 239.76
xwallpaper --center /home/$NUSER/.sys/wallpaper/*
xset r rate 300 50
xbindkeys &
unclutter -idle 1 &
setxkbmap -option caps:escape
numlockx &
/home/$NUSER/.sys/statusbar/time.sh &

# Launch apps
discord &
dunst &

exec dwm
