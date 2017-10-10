#Battery level watcher

acpi -b | awk -F'[,:%]' '{print $2, $3}' | {
	read -r status capacity

	if [ $status = Discharging ]; then
        if [ "$1" = "warning" ]; then
            systemctl hybrid-sleep
        elif [ $capacity -le 10 ]; then
            notify-send -u urgent "Battery low, hybrid sleep in 2m. Plug the adapter !"
            #Run myself in 2m, if the battery is still discarging shutdown.
            sleep 2m
            ./$0 warning
        elif [ $capacity -le 20 ]; then
            notify-send "Battery warning: 20%"
        fi 
	fi
}
