term='quake'
match="\"$term\",\"URxvt\""
wins=$(bspc query -N)
cur_desktop=$(bspc query -D -d focused)
should_spawn=""
for win in $wins; do
	if [ $(xprop -id $win WM_CLASS | tr -d ' ' | cut -d '=' -f 2) == $match ]
	then # We found a match, the quake is already open
		if [ $cur_desktop == $(bspc query -D -n $win) ]
		then #Toggle hidden
			bspc node $win --flag hidden
		else 
			bspc node $win --flag hidden=off
			bspc node $win --to-desktop $cur_desktop
		fi
        bspc node $win --state floating
        bspc node $win --focus
		should_spawn="no"
		break
	fi;\
done;
if [ -z $should_spawn ]
then
	urxvtc -geometry 191x10+0+27 -name $term #-e "ZDOTDIR=~/.config/sxhkd/zsh-quake zsh -i"
fi;

