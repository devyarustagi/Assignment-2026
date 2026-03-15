#!/bin/bash
source ./colors.bash
#print ASCII Header
echo -n $orange
echo '                         /$$$$$$$   /$$$$$$  /$$   /$$ /$$$$$$$   /$$$$$$  /$$$$$$$  /$$$$$$$$ /$$     /$$ /$$$$$$$  /$$$$$$$$'
echo '                        | $$__  $$ /$$__  $$| $$$ | $$| $$__  $$ /$$__  $$| $$__  $$|__  $$__/|  $$   /$$/| $$__  $$| $$_____/'
echo '                        | $$  \ $$| $$  \ $$| $$$$| $$| $$  \ $$| $$  \ $$| $$  \ $$   | $$    \  $$ /$$/ | $$  \ $$| $$      '
echo '                        | $$$$$$$ | $$$$$$$$| $$ $$ $$| $$  | $$| $$$$$$$$| $$$$$$$/   | $$     \  $$$$/  | $$$$$$$/| $$$$$   '
echo '                        | $$__  $$| $$__  $$| $$  $$$$| $$  | $$| $$__  $$| $$__  $$   | $$      \  $$/   | $$____/ | $$__/   '
echo '                        | $$  \ $$| $$  | $$| $$\  $$$| $$  | $$| $$  | $$| $$  \ $$   | $$       | $$    | $$      | $$      '
echo '                        | $$$$$$$/| $$  | $$| $$ \  $$| $$$$$$$/| $$  | $$| $$  | $$   | $$       | $$    | $$      | $$$$$$$$'
echo '                        |_______/ |__/  |__/|__/  \__/|_______/ |__/  |__/|__/  |__/   |__/       |__/    |__/      |________/'

echo $normal
words=0
while getopts ":w:" flag ; do
    case "${flag}" in
        w)
            if (( OPTARG < 1 || OPTARG > 359 )); then
                echo "Invalid value $OPTARG: must be between 0 and 360."
                kill -INT $$
            fi
            words=${OPTARG}
            ;;
        ?)
            echo "Invalid flag -$OPTARG. Exiting..." 
            kill -INT $$
            ;;
        :)
            echo "The flag -$OPTARG requires a number between 0 and 360. Exiting..."
            kill -INT $$
            ;;
    esac
done

while true; do 
    read -e -n 1 -p "Enter Ctrl+C to exit, or enter any other key to play:"
    if (( words == 0 )); then
        read -e -n 4 -p "Enter the number of words, greater than 0 and less than 360: " words
        if (( words < 1 || words > 359 )); then
            echo "Invalid input"
            continue
        fi
    fi
    echo -n $blue
    string=$(shuf -n $words ./wordlist.txt)
    length=${#string}
    string="${string//$'\x0a'/$'\x20'}"
    mapfile -t text <<< "$string"
    for (( i=0; i < length; i++ )); do
        echo -n "${text[${i}]} "
    done
    echo $normal

    read -p "Press ENTER to start the test. Type ! when you are done typing:"
    SECONDS=0
    correct=0
    cursor_position=-1
    usr_input=""
    while (( cursor_position < length-1 )); do 
        read -s -n 1 -r -d ""
        if [[ "$REPLY" == "!" ]]; then
            break
        elif [[ "$REPLY" == $'\x7f' && $cursor_position -eq -1 ]]; then
            continue
        else 
            if [[ "$REPLY" != $'\x7f' ]]; then
                (( cursor_position++ ))
                usr_input="${usr_input}${REPLY}"
                if [[ "${usr_input:$cursor_position:1}" == "${string:$cursor_position:1}" ]]; then
                    (( correct++ ))
                    echo -n $green
                    echo -n "$REPLY"
                    echo -n $normal
                else 
                    echo -n $red
                    echo -n "$REPLY"
                    echo -n $normal
                fi
            else
                if [[ "${usr_input:$cursor_position:1}" == "${string:$cursor_position:1}" ]]; then
                    (( correct-- ))
                fi
                usr_input="${usr_input:0:cursor_position}"
                echo -e -n "\b \b"
                (( cursor_position-- ))
            fi
        fi
    done
    time=$SECONDS
    echo
    input_len=${#usr_input}
    if (( input_len == 0 )); then
        echo "No input entered"
        continue
    fi
    accuracy=$(echo "scale=2; ($correct*100)/$length" | bc)
    wpm=$(echo "scale=2; ($correct/5)/($time/60)" | bc) 
    echo "Your accuracy is $accuracy% and wpm is $wpm"
done




