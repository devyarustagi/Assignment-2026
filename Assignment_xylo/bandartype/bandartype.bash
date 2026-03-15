#!/bin/bash
source ./colors.bash
#print ASCII Header
#echo centered, argument is string
echoc(){
    local columns=$(tput cols)
    local len=${#2}
    if (( len >= columns ));then
        if [[ "$1" == "-n" ]]; then
            echo -n "$2"
        else
            echo "$2"
        fi
    else
        for (( i=1; i<= columns/2 - len/2; i++ )); do
            echo -n " "
        done
        if [[ "$1" == "-n" ]]; then
            echo -n "$2"
        else
            echo "$2"
        fi
    fi
}
echo -n $orange
echoc -N '/$$$$$$$   /$$$$$$  /$$   /$$ /$$$$$$$   /$$$$$$  /$$$$$$$  /$$$$$$$$ /$$     /$$ /$$$$$$$  /$$$$$$$$'
echoc -N '| $$__  $$ /$$__  $$| $$$ | $$| $$__  $$ /$$__  $$| $$__  $$|__  $$__/|  $$   /$$/| $$__  $$| $$_____/'
echoc -N '| $$  \ $$| $$  \ $$| $$$$| $$| $$  \ $$| $$  \ $$| $$  \ $$   | $$    \  $$ /$$/ | $$  \ $$| $$      '
echoc -N '| $$$$$$$ | $$$$$$$$| $$ $$ $$| $$  | $$| $$$$$$$$| $$$$$$$/   | $$     \  $$$$/  | $$$$$$$/| $$$$$   '
echoc -N '| $$  \ $$| $$  | $$| $$\  $$$| $$  | $$| $$  | $$| $$  \ $$   | $$       | $$    | $$      | $$      '
echoc -N '| $$$$$$$/| $$  | $$| $$ \  $$| $$$$$$$/| $$  | $$| $$  | $$   | $$       | $$    | $$      | $$$$$$$$'
echoc -N '|_______/ |__/  |__/|__/  \__/|_______/ |__/  |__/|__/  |__/   |__/       |__/    |__/      |________/'

echo $normal
words=0
difficulty=0


while getopts ":w:d:" flag ; do
    case "${flag}" in
        w)
            if (( OPTARG < 1 || OPTARG > 359 )); then
                echoc -N "Invalid value $OPTARG: must be between 0 and 360."
                kill -INT $$
            fi
            words=${OPTARG}
            ;;
        d)
            if (( OPTARG > 3 || OPTARG < 0 )); then
                echoc -N "Invalid value $OPTARG: difficulty must be either of 1(easy), 2(medium) or 3(hard). Exiting..."
                kill -INT $$
            fi
            difficulty=${OPTARG}
            ;;
        '?')
            echoc -N "Invalid flag -$OPTARG. Exiting..." 
            kill -INT $$
            ;;
        :)
            echoc -N "The flag -$OPTARG requires a number between 0 and 360. Exiting..."
            kill -INT $$
            ;;
    esac
done

while true; do 
    echoc -n "Enter Ctrl+C to exit, or enter any other key to play:"
    read -e -n 1 
    if (( words == 0 )); then
        echoc -n "Enter the number of words, greater than 0 and less than 360: "
        read -e -n 4 words
        if (( words < 1 || words > 359 )); then
            echoc -N "Invalid input"
            words=0
            difficulty=0
            continue
        fi
    fi
    if (( difficulty == 0 )); then
        echoc -n "Enter the difficulty you want: 1(easy), 2(medium) or 3(hard): "
        read -e -n 1 difficulty
        if (( difficulty < 1 || difficulty > 3 )); then
            echoc -N "Invalid input"
            words=0
            difficulty=0
            continue
        fi
    fi
    echo -n $blue
    if (( difficulty == 1)); then
        string=$(shuf -n $words ./easy.txt)
    elif (( difficulty == 2 )); then
        string=$(shuf -n $words ./medium.txt)
    else
        string=$(shuf -n $words ./hard.txt)
    fi
    length=${#string}
    string="${string//$'\x0a'/$'\x20'}"
    mapfile -t text <<< "$string"
    for (( i=0; i < length; i++ )); do
        echo -n "${text[${i}]} "
    done
    echo $normal

    echoc -n "Press ENTER to start the test. Type ! when you are done typing:"
    read
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
        echoc -N "No input entered"
        words=0
        difficulty=0
        continue
    fi
    accuracy=$(echo "scale=2; ($correct*100)/$length" | bc)
    wpm=$(echo "scale=2; ($correct/5)/($time/60)" | bc) 
    echoc -N "Your accuracy is $accuracy% and wpm is $wpm"
    words=0
    difficulty=0
done




