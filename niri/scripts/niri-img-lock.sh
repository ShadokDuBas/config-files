#!/bin/sh
# sreenshot and save to lockpaper
# grim - > /tmp/lockpaper;
niri msg action screenshot-screen --path /tmp/lockpaper;

# niri screenshot is not instant
sleep 0.15

# Times the screen off and puts it to background
swayidle -w timeout 400 'systemctl suspend' &

# Locks the screen immediately
swaylock -i /tmp/lockpaper
# Kills last background task so idle timer doesn't keep running
kill %%
