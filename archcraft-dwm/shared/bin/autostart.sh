#!/usr/bin/env bash

## Copyright (C) 2020-2023 Aditya Shakya <adi1090x@gmail.com>
## Autostart Programs

# Kill already running process
_ps=(picom dunst ksuperkey mpd xfce-polkit xfce4-power-manager dwmbar)
for _prs in "${_ps[@]}"; do
	if [[ `pgrep ${_prs}` ]]; then
		killall -9 ${_prs}
	fi
done

# Fix cursor
xsetroot -cursor_name left_ptr

# Polkit agent
/usr/lib/xfce-polkit/xfce-polkit &

# Restore wallpaper
hsetroot -cover /usr/share/archcraft/dwm/wallpapers/default.png

# Lauch dwmbar
/usr/share/archcraft/dwm/bin/dwmbar.sh &

# Lauch notification daemon
/usr/share/archcraft/dwm/bin/dwmdunst.sh

# Lauch compositor
/usr/share/archcraft/dwm/bin/dwmcomp.sh

# Fix Java problems
wmname "LG3D"
export _JAVA_AWT_WM_NONREPARENTING=1

## Add your autostart programs here --------------
xset r rate 260 60
flameshot &
spotify &

if [[ "$USER" = "pedroma" ]]; then
  slack &
  obs &
fi


## -----------------------------------------------

# Launch DWM
while dwm; [ $? -ne 0  ]; do echo "start dwm"; done
