#!/bin/bash

# https://stackoverflow.com/questions/24998434/read-command-display-the-prompt-in-color-or-enable-interpretation-of-backslas
# https://www.ditig.com/256-colors-cheat-sheet
# Terminal Font Formatting
RESET="\e[0m"
BOLD="\e[1m"
ITALIC="\e[3m"
UNDERLINE="\e[4m"
STRIKETHROUGH="\e[9m"

FTBLACK="\e[30m"
FTRED="\e[31m"
FTGREEN="\e[32m"
FTYELLOW="\e[33m"
FTBLUE="\e[34m"
FTPURPLE="\e[35m"
FTCYAN="\e[36m"
FTWHITE="\e[37m"

FTBLACKDARK="\e[90m"
FTREDDARK="\e[91m"
FTGREENDARK="\e[92m"
FTYELLOWDARK="\e[93m"
FTBLUEDARK="\e[94m"
FTPURPLEDARK="\e[95m"
FTCYANDARK="\e[96m"
FTWHITEDARK="\e[97m"

BTBLACK="\e[40m"
BTRED="\e[41m"
BTGREEN="\e[42m"
BTYELLOW="\e[43m"
BTBLUE="\e[44m"
BTPURPLE="\e[45m"
BTCYAN="\e[46m"
BTWHITE="\e[47m"

BTBLACKHIGH="\e[100m"
BTREDHIGH="\e[101m"
BTGREENHIGH="\e[102m"
BTYELLOWHIGH="\e[103m"
BTBLUEHIGH="\e[104m"
BTPURPLEHIGH="\e[105m"
BTCYANHIGH="\e[106m"
BTWHITEHIGH="\e[107m"

# Foreground RGB: '\e[38;2;R;G;Bm'
# Background RGB: '\e[48;2;R;G;Bm'
FRED="\e[38;2;255;0;0m"
FGREEN="\e[38;2;0;255;0m"
FGOLD1="\e[38;2;255;215;0m"
FPINK1="\e[38;2;255;175;215m"
FORANGE="\e[38;2;255;165;0"

CLEARLINE="\e[2K"

justify() {
    max_length=78
    args_length=${#1}
    remaining_length=$((max_length - args_length))
    printf "%b" "${1}"
    eval printf "%.0s." {1..${remaining_length}}
    printf "%s" "${2}"
    printf "\e[0m\n"
}

# https://gist.github.com/SamEureka/3e61942d37256550b40d0ffe75bc22c4
# Define an array of Braille patterns for a spinner
six_dot_cell_pattern=("⠙" "⠹" "⠸" "⠼" "⠴" "⠦" "⠧" "⠇")
eight_dot_cell_pattern=("⣾" "⢿" "⡿" "⣷" "⣯" "⢟" "⡻" "⣽")

# Set the pattern
braille_spinner=("${eight_dot_cell_pattern[@]}")

# Set the duration for each spinner frame (in seconds)
frame_duration=0.1

# Function to start the spinner in the background
start_spinner() {
    tput civis # hide cursor
    (
        spinner_index=0
        while :; do
            printf "\r%s " "${braille_spinner[spinner_index]}"              # set cursor to column 0 and show spinner
            spinner_index=$(((spinner_index + 1) % ${#braille_spinner[@]})) # rotate spinner
            sleep "$frame_duration"
        done
    ) &
    spinner_pid=$!
    # echo -en "\e[s" # save cursor
    echo -en "  $1" # display message
    disown
}

# Function to stop the spinner with U+2800
stop_spinner() {
    kill -9 "$spinner_pid" # Stop the spinner loop
    tput cnorm             # show cursor
    # echo -en "\e[u"      # restore cursor
    echo -en "\e[2K\r" # Clear the line and set cursor to column 0
    justify "$@"       # display message
}
