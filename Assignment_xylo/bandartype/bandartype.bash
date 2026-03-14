#!/bin/bash
source colors.bash
#print ASCII Header
echo -n $green
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



while true; do 
    read -e -n 1 -p "Enter q to exit, or enter any other key to play:" PLAY
    if [[ "$PLAY" == "q" ]]; then
        echo "Exiting..."
        exit
    fi
    echo -n $normal
    echo -n $blue
    string=$(shuf -n 4 wordlist.txt)
    cat <<< "$string"
    echo $normal
    read -a words <<< "$string"
    length=${#string}
    read -p "Press ENTER to start the test. Type ! when you are done typing:"
    SECONDS=0
    read -e -d "!" usr_input
    time=$SECONDS
    echo
    inputsize=${#usr_input}
    correct=0
    for (( i=0; i<$length && i<$inputsize; i++ )); do
        if [[ "${usr_input:$i:1}" == "${string:$i:1}" ]]; then
            correct=$((correct+1))
        fi
    done
    accuracy=$(echo "scale=2; ($correct*100)/$length" | bc)
    wpm=$(echo "scale=2; ($correct/5)/($time/60)" | bc) 
    echo "Your accuracy is $accuracy% and wpm is $wpm"
done




