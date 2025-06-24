#!/usr/bin/env bash 

# *keyword* - This will match files that start with any number of characters,
# followed by keyword, and ending with any number of characters
orientation=""
tilt=""

#Accelerometer orientation changed: bottom-up
#    Tilt changed: face-down
#    Tilt changed: tilted-down
#    → Tablet Mode normal 

#Accelerometer orientation changed: normal
#    Tilt changed: face-down
#    Tilt changed: tilted-down
#    → Tablet Mode normal + flipped 180 degrees. 

# bottom-up → bottom of the laptop display is pointing upwards. 

monitor-sensor | while read -r line; do
    case "$line" in
        *normal*)
            echo "Normal Display Mode!"
            orientation="normal" 
            ;;
        *right-up*)
            echo "right-up!"
            orientation="right-up"
            ;;
        *left-up*)
            echo "left-up!"
            orientation="left-up"
            ;;
        *bottom-up*)
            echo "bottom-up"
            orientation="bottom-up"
            ;;
        *tilted-up*)
            echo "tilted-up"
            tilt="tilted-up"
            ;;
        *tilted-down*)
            echo "tilted-down"
            tilt="tilted-down"
            ;;
        *vertical*)
            echo "vertical"
            tilt="vertical"
            ;;
        *face-down*)
            echo "face-down"
            tilt="face-down"
            ;;
    esac
   
    if [[ "$orientation" == "bottom-up" ]]; then
        echo "→ Tablet Mode normal [180 degree Rotation NEEDED]"
        wlr-randr --output eDP-2 --transform 180
        if [[ "$tilt" == "face-down" ]]; then
            echo "→ Tablet Mode bottom-up + face-down [DEACTIVATE KEYBOARD?]"
        elif [[ "$tilt" == "vertical" ]]; then
            echo "→ Tablet Mode normal [VERTICAL]"
        fi
    elif [[ "$orientation" == "normal" ]]; then
            echo "→ Tablet Mode normal [NO Rotation NEEDED]"
            wlr-randr --output eDP-2 --transform normal
        if [[ "$tilt" == "face-down" ]]; then
            echo "→ Tablet Mode normal + face-down [DEACTIVATE KEYBOARD?]"
        fi
    elif [[ "$orientation" == "left-up" ]]; then
        if [[ "$tilt" == "vertical" ]]; then
            wlr-randr --output eDP-2 --transform 90
            echo "Vertical Left Side Up!"
        fi
    elif [[ "$orientation" == "right-up" ]]; then
        if [["$tilt" == "vertical" ]]; then
            wlr-randr --output eDP-2 --transform 270
            echo "Vertical Right Side Up!"
        fi
    fi

done

