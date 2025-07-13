#!/bin/bash

# Spinning line animation using single characters
spinner() {
    
    local chars="◴◷◶◵"
    local i=0
    
    echo -n ""
    while true; do
        printf "\r\033[K%s" "${chars:$i:1}"
        sleep 1
        i=$(( (i + 1) % 4 ))
    done
}

# Snake-like moving dot animation
snake() {
    local width=20
    local pos=0
    local direction=1
    
    while true; do
        printf "\r\033[K["
        for ((i=0; i<width; i++)); do
            if [ $i -eq $pos ]; then
                printf "●"
            else
                printf " "
            fi
        done
        printf "]"
        
        pos=$((pos + direction))
        if [ $pos -eq $width ] || [ $pos -eq -1 ]; then
            direction=$((direction * -1))
            [ $pos -eq $width ] && pos=$((width - 1))
            [ $pos -eq -1 ] && pos=0
        fi
        
        sleep 0.1
    done
}

# Pulsing star animation
pulse() {
    local chars="·∶∷∷∶·"
    local i=0
    
    while true; do
        printf "\r\033[K    %s    " "${chars:$i:1}"
        sleep 0.3
        i=$(( (i + 1) % ${#chars} ))
    done
}


# Menu to choose animation
echo "Choose an animation:"
echo "1) Spinning loader"
echo "2) Snake dot"
echo "3) Pulsing star"
echo ""
echo "Enter choice (1-4): " 
read choice

case $choice in
    1) spinner ;;
    2) snake ;;
    3) pulse ;;
    *) echo "Invalid choice" ;;
esac