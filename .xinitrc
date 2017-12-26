#!/bin/sh

userresources=$HOME/.Xresources
usermodmap=$HOME/.Xmodmap
sysresources=/etc/X11/xinit/.Xresources
sysmodmap=/etc/X11/xinit/.Xmodmap

# merge in defaults and keymaps

if [ -f $sysresources ]; then
    xrdb -merge $sysresources
fi

if [ -f $sysmodmap ]; then
    xmodmap $sysmodmap
fi

if [ -f "$userresources" ]; then
    xrdb -merge "$userresources"
fi

if [ -f "$usermodmap" ]; then
    xmodmap "$usermodmap"
fi

# start some nice programs

if [ -d /etc/X11/xinit/xinitrc.d ] ; then
 for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
  [ -x "$f" ] && . "$f"
 done
 unset f
fi

#xinput set-prop MOSART\ Semi.\ 2.4G\ Wireless\ Mouse Coordinate\ Transformation\ Matrix 0.3 0 0 0 0.3 0 0 0 1
setxkbmap fr
xinput set-prop SynPS/2\ Synaptics\ TouchPad libinput\ Tapping\ Enabled 1
numlockx on
#xsetroot -cursor_name left_ptr #Cursor on root is left arrow

#exec startlxde
#exec awesome
#exec bspwm
exec i3
