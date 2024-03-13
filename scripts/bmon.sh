#!/usr/bin/env bash

#Create files if doesnt exists
if [ ! -f "/tmp/bmon_notif" ]; then
    echo "1" > /tmp/bmon_notif
    echo "1" > /tmp/bmon_notif_low0
    echo "1" > /tmp/bmon_notif_low1
    echo "1" > /tmp/bmon_notif_low2
    echo "1" > /tmp/bmon_closed
fi

# Get battery percentage and state
percent=$(acpi -b | grep -oP '\d+%' | tr -d '%')
state=$(acpi -b | grep -oP "Discharging|Charging|Full|Unknown|Not charging")
if [[ $state == "Charging" ]]||[[ $state == "Not charging" ]]||[[ $state == "Full" ]];then
    if [[ $(cat /tmp/bmon_closed) == "0" ]]; then
        dunstctl close $(dunstctl history | jq -r '.data[] | select(.[].message.data == "<b>Battery is Discharging</b>") | .[].id.data'| tail -1)
        echo 1 > /tmp/bmon_closed
    fi

    color="#a6e3a1"
    symbol="󰂄"
    echo "1" > /tmp/bmon_notif
    echo "1" > /tmp/bmon_notif_low0
    echo "1" > /tmp/bmon_notif_low1
    echo "1" > /tmp/bmon_notif_low2

elif [[ $state == "Unknown" ]];then
    color "#f57d85"
    symbol=""
    echo "0" > /tmp/bmon_notif

elif [[ $state == "Discharging" ]];then
    if [[ $(cat /tmp/bmon_notif) == "1" ]];then
        notify-send -u critical -t 0 "Battery is Discharging"
        echo "0" > /tmp/bmon_notif
        echo 0 > /tmp/bmon_closed
    fi
    if [[ percent -lt 10 ]];then
    if [[ $(cat /tmp/bmon_notif_low0) == "1" ]];then
        i3-nagbar -f 12 -m 'YOUR BATTERY IS VERY LOW (10%) CHARGE NOW!!!!!'&
	echo "0" > /tmp/bmon_notif_low0
    fi
        color="#FFFFFF"
        symbol="󱃍"
    elif [[ percent -lt 20 ]];then
    if [[ $(cat /tmp/bmon_notif_low1) == "1" ]];then
        notify-send -u critical -t 0 "Low Battery (20%)"
	echo "0" > /tmp/bmon_notif_low1
    fi
        color="#f57d85"
        symbol="󰁺"
    elif [[ percent -lt 30 ]];then
    if [[ $(cat /tmp/bmon_notif_low2) == "1" ]];then
        notify-send "Low Battery (30%)"
	echo "0" > /tmp/bmon_notif_low2
    fi
        color="#f38ba8"
        symbol="󰁻"
    elif [[ percent -lt 40 ]];then
	echo "1" > /tmp/bmon_notif_low
        color="#ed978c"
        symbol="󰁼"
    elif [[ percent -lt 50 ]];then
        color="#edbd8c"
        symbol="󰁽"
    elif [[ percent -lt 60 ]];then
        color="#edbd8c"
        symbol="󰁾"
    elif [[ percent -lt 70 ]];then
        color="#e6cb93"
        symbol="󰁿"
    elif [[ percent -lt 80 ]];then
        color="#e6e393"
        symbol="󰂀"
    elif [[ percent -lt 90 ]];then
        color="#c0e388"
        symbol="󰂁"
    else
        color="#a6e3a1"
        symbol="󰁹"
    fi
fi
echo "<span color=\"$color\">$symbol $percent</span>"
