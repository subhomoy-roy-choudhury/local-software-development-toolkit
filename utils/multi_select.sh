#!/bin/bash

# Check if whiptail is available
if ! command -v whiptail >/dev/null; then
    echo "whiptail is not installed."
    exit 1
fi

# Display the multi-select menu using whiptail
CHOICES=$(whiptail --title "Menu" --checklist \
"Choose options:" 15 60 5 \
"1" "Option 1" OFF \
"2" "Option 2" OFF \
"3" "Option 3" OFF \
"4" "Option 4" OFF \
3>&1 1>&2 2>&3)

# Handle the selected options
for choice in $CHOICES
do
    case $choice in
        "1")
            echo "Option 1 selected"
            ;;
        "2")
            echo "Option 2 selected"
            ;;
        "3")
            echo "Option 3 selected"
            ;;
        "4")
            echo "Option 4 selected"
            ;;
    esac
done
