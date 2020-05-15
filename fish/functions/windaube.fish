# Defined in - @ line 1
function windaube --description 'Reboot to windows and bypass boot loader menu'
    systemctl reboot --boot-loader-menu=1 --boot-loader-entry=auto-windows;
end
