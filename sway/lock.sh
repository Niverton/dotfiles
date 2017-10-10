tmp=$(mktemp --suffix='.png')

swaygrab $tmp
mogrify -scale 5% -scale 2000% $tmp

swaylock -i $tmp
#feh $tmp

rm $tmp

#Is adapter present:
adapter=$(cat /sys/class/power_supply/ADP1/online)
if [ $adapter -eq 0 ]; then 
    pgrep swaylock && (sleep 180; pgrep swaylock && systemctl suspend) #Suspend after total of 5min
fi

