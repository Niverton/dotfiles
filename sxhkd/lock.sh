#Prevent lock if app is in fullscreen on the current desktop
fs=$(bspc query -N -d -n .fullscreen | tr -d "[ \t\n]")
[[ -n $fs ]] && exit

tmp=$(mktemp --suffix='.png')

import -window root $tmp
mogrify -scale 5% -scale 2000% $tmp

i3lock -efi $tmp
#feh $tmp

rm $tmp

sleep 60; pgrep i3lock && xset dpms force off # Turn display off after delay

#Is adapter present:
adapter=$(cat /sys/class/power_supply/ADP1/online)
if [ $adapter -eq 0 ]; then 
    pgrep i3lock && (sleep 180; pgrep i3lock && systemctl suspend && xset dpms force on) #Suspend after total of 5min
fi

