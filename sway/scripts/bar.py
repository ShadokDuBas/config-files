#!/bin/python
# script to show/hide bar depending on circumstances

# Battery time left threshold (minutes)
bat_minsleft_low = 30

# Ram usage threshold (percent)
ram_percent_low = 80

# Update period (seconds)
update_period = 1

# Resist duration (seconds)
resist_dur_secs = 5

import subprocess
import traceback
import psutil
from time import sleep

bar_show = None

def show_bar(show):
    global bar_show
    if show != bar_show:
        bar_show = show
        last_update_secs = 0
        subprocess.run(["swaymsg", "bar", "mode", "dock" if show else "hide"], check=True)
        sleep(resist_dur_secs)
    else:
        sleep(update_period)

def bat_show():
    bat = psutil.sensors_battery()
    if bat.power_plugged in [None, True]: return False
    if bat.secsleft <= 0: return False
    bat_minsleft = bat.secsleft / 60
    return bat_minsleft < bat_minsleft_low

def ram_show():
    ram_percent = psutil.virtual_memory().percent
    return ram_percent > ram_percent_low

def main():
    while True:
        show_bar(bat_show() or ram_show())

def guarded_main():
    while True:
        try:
            main()
        except:
            ret = subprocess.run(["zenity", "--question", "--no-markup", "--title", "Bar script crashed", "--text", traceback.format_exc() + "\n Try again?"]).returncode
            if ret > 0:
                break

if __name__ == "__main__":
    guarded_main()
