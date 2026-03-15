#!/bin/bash
source ./colors.bash
#print ASCII Header
echo -n $orange
base64 -d <<< 'ICAgICAgICAgICAgICAgICAgICAgICAgIC8kJCQkJCQkICAgLyQkJCQkJCAgLyQkICAgLyQkIC8k
JCQkJCQkICAgLyQkJCQkJCAgLyQkJCQkJCQgIC8kJCQkJCQkJCAvJCQgICAgIC8kJCAvJCQkJCQk
JCAgLyQkJCQkJCQkCiAgICAgICAgICAgICAgICAgICAgICAgICB8ICQkX18gICQkIC8kJF9fICAk
JHwgJCQkIHwgJCR8ICQkX18gICQkIC8kJF9fICAkJHwgJCRfXyAgJCR8X18gICQkX18vfCAgJCQg
ICAvJCQvfCAkJF9fICAkJHwgJCRfX19fXy8KICAgICAgICAgICAgICAgICAgICAgICAgIHwgJCQg
IFwgJCR8ICQkICBcICQkfCAkJCQkfCAkJHwgJCQgIFwgJCR8ICQkICBcICQkfCAkJCAgXCAkJCAg
IHwgJCQgICAgXCAgJCQgLyQkLyB8ICQkICBcICQkfCAkJCAgICAgIAogICAgICAgICAgICAgICAg
ICAgICAgICAgfCAkJCQkJCQkIHwgJCQkJCQkJCR8ICQkICQkICQkfCAkJCAgfCAkJHwgJCQkJCQk
JCR8ICQkJCQkJCQvICAgfCAkJCAgICAgXCAgJCQkJC8gIHwgJCQkJCQkJC98ICQkJCQkICAgCiAg
ICAgICAgICAgICAgICAgICAgICAgICB8ICQkX18gICQkfCAkJF9fICAkJHwgJCQgICQkJCR8ICQk
ICB8ICQkfCAkJF9fICAkJHwgJCRfXyAgJCQgICB8ICQkICAgICAgXCAgJCQvICAgfCAkJF9fX18v
IHwgJCRfXy8gICAKICAgICAgICAgICAgICAgICAgICAgICAgIHwgJCQgIFwgJCR8ICQkICB8ICQk
fCAkJFwgICQkJHwgJCQgIHwgJCR8ICQkICB8ICQkfCAkJCAgXCAkJCAgIHwgJCQgICAgICAgfCAk
JCAgICB8ICQkICAgICAgfCAkJCAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgfCAkJCQk
JCQkL3wgJCQgIHwgJCR8ICQkIFwgICQkfCAkJCQkJCQkL3wgJCQgIHwgJCR8ICQkICB8ICQkICAg
fCAkJCAgICAgICB8ICQkICAgIHwgJCQgICAgICB8ICQkJCQkJCQkCiAgICAgICAgICAgICAgICAg
ICAgICAgICB8X19fX19fXy8gfF9fLyAgfF9fL3xfXy8gIFxfXy98X19fX19fXy8gfF9fLyAgfF9f
L3xfXy8gIHxfXy8gICB8X18vICAgICAgIHxfXy8gICAgfF9fLyAgICAgIHxfX19fX19fXy8KICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCg=='

echo $normal

while true; do 
    read -e -n 1 -p "Enter Ctrl+C to exit, or enter any other key to play:"
    read -e -n 4 -p "Enter the number of words, greater than 0 and less than 360: " words
    if (( words < 1 || words > 359 )); then
        echo "Invalid input"
        continue
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




