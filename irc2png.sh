#!/bin/bash

VERSION="0.01"

if [[ "$1" = "-v" || "$1" = "--version" ]]; then
    echo "irc2png version 0.01,
    Render beautiful animated PNG sequences from IRC logs
    
    Created by Tobiasz 'unfa\' Karoń
    Released under the GPL 3.0 license
    
    Get updates and contribute on Github:
    https://github.com/unfa/irc2png"
    exit
fi

if [[ "$1" = "" || "$2" = "" || "$1" = "-h" || "$1" = "--help" ]]; then
    echo "Usage: irc2png [IRC log file] [SVG template file]
    
    example:
    
        ./irc2png.sh irc.txt template.svg
        
    Will render the IRC log from file irc.txt usiing template.svg for visual processing and put the resulting PNG sequence into the subdirectory './irc2png'.
    
    Commandline options:
        
    -h --help       Display this help screen
    -v --version    Show version information"
    exit
fi



IRC=$1
SVG=$2

if [[ -e "./irc2png" ]]; then
    echo "Fatal error! The irc2png directory exists - please delete it or move it to ensure there will be no accidental data loss."
    exit
fi

mkdir irc2png
cd irc2png

TIME8=""; USER8=""; MESSAGE8=""
TIME7=""; USER7=""; MESSAGE7=""
TIME6=""; USER6=""; MESSAGE6=""
TIME5=""; USER5=""; MESSAGE5=""
TIME4=""; USER4=""; MESSAGE4=""
TIME3=""; USER3=""; MESSAGE3=""
TIME2=""; USER2=""; MESSAGE2=""
TIME1=""; USER1=""; MESSAGE1=""
TIME="";  USER="";  MESSAGE=""

NOW=$(head -n 1 "../$IRC" | grep -o "^\[..:..:..\]" | cut -c 2- | rev | cut -c 2- | rev)

NOW_S=$(date +'%s' -d "$NOW")

echo "NOW: $NOW; NOW_S: $NOW_S"

N=0

while read line; do
    echo "NOW_S: $NOW_S"
    
    TIME=$(echo $line | grep -o "^\[..:..:..\]" | cut -c 2- | rev | cut -c 2- | rev) 
    USER=$(echo $line | grep -o " <.*> " | cut -c 3- | rev | cut -c 3- | rev)
    MESSAGE=$(echo $line | grep -o "> .*$" | cut -c 3-)
    
    TIME_S=$(date +'%s' -d "$TIME")
    
    echo "TIME_S: $TIME_S; USER: $USER; MESSAGE: $MESSAGE"
        
    # render a frame
    
    cp "../$SVG" -f template.svg
    
    sed -i "s/%TIME1%/$TIME1/" template.svg
    sed -i "s/%TIME2%/$TIME2/" template.svg
    sed -i "s/%TIME3%/$TIME3/" template.svg
    sed -i "s/%TIME4%/$TIME4/" template.svg
    sed -i "s/%TIME5%/$TIME5/" template.svg
    sed -i "s/%TIME6%/$TIME6/" template.svg
    sed -i "s/%TIME7%/$TIME7/" template.svg
    sed -i "s/%TIME8%/$TIME8/" template.svg
    
    sed -i "s/%USER1%/$USER1/" template.svg
    sed -i "s/%USER2%/$USER2/" template.svg
    sed -i "s/%USER3%/$USER3/" template.svg
    sed -i "s/%USER4%/$USER4/" template.svg
    sed -i "s/%USER5%/$USER5/" template.svg
    sed -i "s/%USER6%/$USER6/" template.svg
    sed -i "s/%USER7%/$USER7/" template.svg
    sed -i "s/%USER8%/$USER8/" template.svg
    
    sed -i "s/%MESSAGE1%/$MESSAGE1/" template.svg
    sed -i "s/%MESSAGE2%/$MESSAGE2/" template.svg
    sed -i "s/%MESSAGE3%/$MESSAGE3/" template.svg
    sed -i "s/%MESSAGE4%/$MESSAGE4/" template.svg
    sed -i "s/%MESSAGE5%/$MESSAGE5/" template.svg
    sed -i "s/%MESSAGE6%/$MESSAGE6/" template.svg
    sed -i "s/%MESSAGE7%/$MESSAGE7/" template.svg
    sed -i "s/%MESSAGE8%/$MESSAGE8/" template.svg

    convert -background none template.svg $(printf "%09d.png" $N)
        
    while [[ $NOW_S -lt $TIME_S ]]; do # now we'll duplicate frames over to pad in the space until anotehr message in the log arrives
    
        N=$((N+1))
        NOW_S=$((NOW_S+1))
        
        cp --reflink $(printf "%09d.png" $((N-1))) $(printf "%09d.png" $N) # using --reflink to only copy file reference - saves disk space on Btrfs and ZFS, may not work on other filesystems?)
    done
    
    # step forward with the messages
    
    TIME8=$TIME7; USER8=$USER7; MESSAGE8=$MESSAGE7
    TIME7=$TIME6; USER7=$USER6; MESSAGE7=$MESSAGE6
    TIME6=$TIME5; USER6=$USER5; MESSAGE6=$MESSAGE5
    TIME5=$TIME4; USER5=$USER4; MESSAGE5=$MESSAGE4
    TIME4=$TIME3; USER4=$USER3; MESSAGE4=$MESSAGE3
    TIME3=$TIME2; USER3=$USER2; MESSAGE3=$MESSAGE2
    TIME2=$TIME1; USER2=$USER1; MESSAGE2=$MESSAGE1
    TIME1=$TIME; USER1=$USER; MESSAGE1=$MESSAGE

done < "../$IRC"
