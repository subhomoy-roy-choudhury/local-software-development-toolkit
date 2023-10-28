multi_select_menu() {
    local prompt="$1"; shift
    local options=("$@")
    local num_options=${#options[@]}
    local selected=()

    # Add "Quit" option
    options+=("Quit")

    while true; do
        # Print options
        echo "$prompt"
        for i in "${!options[@]}"; do 
            echo "$((i+1)). ${options[$i]}"
        done

        # Read multi-selection from user
        read -r -p "Enter selection (space-separated numbers, 'Quit' to stop): " selections

        # Check if 'Quit' is selected
        if echo "$selections" | grep -q "$((num_options+1))"; then
            echo "You selected 'Quit'. Exiting."
            exit 1
        fi

        # Clear previous selections
        selected=()

        # Process selections
        for sel in $selections; do
            if [ "$sel" -ge 1 ] && [ "$sel" -le "$num_options" ]; then # Change here to prevent "Quit" from being a valid selection
                selected+=("${options[$sel-1]}")
            else
                echo "Invalid option: $sel"
            fi
        done

        # Break loop if selections are valid
        [[ ${#selected[@]} -ne 0 ]] && break

        echo "Please make a valid selection."
    done

    # Print selected options separated by a delimiter (e.g., comma)
    local IFS=, # IFS is the internal field separator in bash. Here it's set to a comma.
    echo "${selected[*]}" # This will print array elements comma-separated, due to IFS
}