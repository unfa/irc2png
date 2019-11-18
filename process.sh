#!/bin/bash

rm -rf temp

mkdir temp

cp irc.txt ./temp

cp chat.svg ./temp

cd temp

TIME8=""; USER8=""; MESSAGE8=""
TIME7=""; USER7=""; MESSAGE7=""
TIME6=""; USER6=""; MESSAGE6=""
TIME5=""; USER5=""; MESSAGE5=""
TIME4=""; USER4=""; MESSAGE4=""
TIME3=""; USER3=""; MESSAGE3=""
TIME2=""; USER2=""; MESSAGE2=""
TIME1=""; USER1=""; MESSAGE1=""
TIME="";  USER="";  MESSAGE=""

NOW=$(head -n 1 irc.txt | grep -o "^\[..:..:..\]" | cut -c 2- | rev | cut -c 2- | rev)

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
    
    while [[ $NOW_S -lt $TIME_S ]]; do
    
        N=$((N+1))
        NOW_S=$((NOW_S+1))

        cp chat.svg chat2.svg
        
        sed -i "s/%TIME1%/$TIME1/" chat2.svg
        sed -i "s/%TIME2%/$TIME2/" chat2.svg
        sed -i "s/%TIME3%/$TIME3/" chat2.svg
        sed -i "s/%TIME4%/$TIME4/" chat2.svg
        sed -i "s/%TIME5%/$TIME5/" chat2.svg
        sed -i "s/%TIME6%/$TIME6/" chat2.svg
        sed -i "s/%TIME7%/$TIME7/" chat2.svg
        sed -i "s/%TIME8%/$TIME8/" chat2.svg
        
        sed -i "s/%USER1%/$USER1/" chat2.svg
        sed -i "s/%USER2%/$USER2/" chat2.svg
        sed -i "s/%USER3%/$USER3/" chat2.svg
        sed -i "s/%USER4%/$USER4/" chat2.svg
        sed -i "s/%USER5%/$USER5/" chat2.svg
        sed -i "s/%USER6%/$USER6/" chat2.svg
        sed -i "s/%USER7%/$USER7/" chat2.svg
        sed -i "s/%USER8%/$USER8/" chat2.svg
        
        sed -i "s/%MESSAGE1%/$MESSAGE1/" chat2.svg
        sed -i "s/%MESSAGE2%/$MESSAGE2/" chat2.svg
        sed -i "s/%MESSAGE3%/$MESSAGE3/" chat2.svg
        sed -i "s/%MESSAGE4%/$MESSAGE4/" chat2.svg
        sed -i "s/%MESSAGE5%/$MESSAGE5/" chat2.svg
        sed -i "s/%MESSAGE6%/$MESSAGE6/" chat2.svg
        sed -i "s/%MESSAGE7%/$MESSAGE7/" chat2.svg
        sed -i "s/%MESSAGE8%/$MESSAGE8/" chat2.svg

        convert -background none chat2.svg chat_$(printf "%09d.png" $N)
    
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

done < irc.txt
