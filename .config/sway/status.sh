#!/bin/bash

bg_bar_color="#282A36"

separator() {
  echo -n "{"
#  echo -n "\"full_text\"\"\":,"
  echo -n "\"separator\":false,"
  echo -n "\"separator_block_width\":0,"
  echo -n "\"border\":\"$bg_bar_color\","
  echo -n "\"border_left\":0,"
  echo -n "\"border_right\":0,"
  echo -n "\"border_top\":2,"
  echo -n "\"border_bottom\":2,"
  echo -n "\"color\":\"$1\","
  echo -n "\"background\":\"$2\""
  echo -n "}"
}



common() {
  echo -n "\"border\": \"$bg_bar_color\","
  echo -n "\"separator\":false,"
  echo -n "\"separator_block_width\":0,"
  echo -n "\"border_top\":2,"
  echo -n "\"border_bottom\":2,"
  echo -n "\"border_left\":0,"
  echo -n "\"border_right\":0"
}

battery0() {
    local bg="#D69E2E"
    separator $bg "#E0E0E0"
    prct=$(cat /sys/class/power_supply/BAT0/capacity)
    chrg=$(cat /sys/class/power_supply/BAT0/status)
    icon=""   
  
    case $chrg in
    "Charging")  icon="";bg="#0000ff"; ;;
    "Not charging") icon="";bg="#ff0000" ;;
    "Unknown") icon="";bg="0000ff" ;;
    "Full") icon="⚡"; bg="ffff00" ;;  
    esac 
echo -n ",{"
    echo -n "\"name\":\"battery0\","
    echo -n "\"full_text\":\" ${icon} ${prct}% \","
    echo -n "\"color\":\"#000000\","
    echo -n "\"background\":\"$bg\","
    common
    echo -n "},"
  
    bg_separator_previous="#E0E0E0"
}

mydate() {
  local bg="#E0E0E0"
  separator $bg "#7F00FF"
  echo -n ",{"
  echo -n "\"name\":\"id_time\","
  echo -n "\"full_text\":\"  $(date "+%a %d/%m %H:%M") \","
  echo -n "\"color\":\"#000000\","
  echo -n "\"background\":\"$bg\","
  common
  echo -n "},"
}


volume() {
  local bg="#673AB7"
  separator $bg $bg_separator_previous  
  vol=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | cut -d : -f 2)
  echo -n ",{"
  echo -n "\"name\":\"id_volume\","
  echo -n "\"background\":\"$bg\","
  echo -n "\"full_text\":\"  ${vol}% \","
  common
  echo -n "},"
  separator $bg_bar_color $bg
}

logout() {
  echo -n ",{"
  echo -n "\"name\":\"id_logout\","
  echo -n "\"full_text\":\"  \","
  echo -n '"align": "left"'
  echo -n "}"
}



# Send the header so that i3bar knows we want to use JSON:
echo '{ "version": 1 , "click_events":true}'

# Begin the endless array.
echo '['

# We send an empty first array of blocks to make the loop simpler:
echo '[]'

# launched in a background process

while :;
do

echo -n ",["
  mydate
  battery0
  volume
  logout
echo "]"

read line;

   echo $line > /tmp/tmp.txt

case  $line  in
 *"name"*"id_time"*) foot /home/kai/.config/sway/click_time.sh & ;;
 *"name"*"id_volume"*) pavucontrol & ;;  

esac

sleep 2 


done
