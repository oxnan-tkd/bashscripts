#!/bin/bash
# based on  https://raw.githubusercontent.com/tinkersec/scratchpad/master/BashScripts/doNmap.sh
USAGE="
Bash wrapper to automatically nmap scan and put into aquatone
Run as root.

usage:   sudo doNmap.sh <port list> <output file name> <CIDR or IP Range or multiple ip's seperated by space>
example: sudo doNmap.sh small "localnetwork" 192.168.1.2 192.168.0.1/24
example: sudo doNmap.sh large somethingsomthing 10.0.0.0/8
example: sudo doNmap.sh huge potatoscan 172.16-31.0-255.0-255

Port selection:
        small:  80, 443
        medium: 80, 443, 8000, 8080, 8443
        large:  80, 81, 443, 591, 2082, 2087, 2095, 2096, 3000, 8000, 8001, 8008, 8080, 8083, 8443, 8834, 8888
        huge:   80, 81, 300, 443, 591, 593, 832, 981, 1010, 1311, 2082, 2087, 2095, 2096, 2480, 3000, 3128, 3333,
                4243, 4567, 4711, 4712, 4993, 5000, 5104, 5108, 5800, 6543, 7000, 7396, 7474, 8000, 8001, 8008,
                8014, 8042, 8069, 8080, 8081, 8088, 8090, 8091, 8118, 8123, 8172, 8222, 8243, 8280, 8281, 8333,
                8443, 8500, 8834, 8880, 8888, 8983, 9000, 9043, 9060, 9080, 9090, 9091, 9200, 9443, 9800, 9981,
                12443, 16080, 18091, 18092, 20720, 28017
"

# Check if running as root.
if [ "$EUID" -ne 0 ]
  then echo "Please run as root or use sudo. (You can trust me... you read the full script, right?)"
  exit
fi

# Check if any flags were set. If not, print out help.
if [ $# -eq 0 ]; then
        echo "$USAGE"
        exit
fi

# Set flags.
while getopts "h" FLAG
do
        case $FLAG in
                h)      echo "$USAGE"
                        exit
                        ;;
                *)
                        echo "$USAGE"
                        exit
                        ;;
        esac
done

FNAME=$2

if [ $1 == "small" ]; then
        nmap "${@:3}" -oX small-$FNAME.xml -p 80,443
        cat small-$FNAME.xml | aquatone -nmap
elif [ $1 == "medium" ]; then
        nmap "${@:3}" -oX medium-$FNAME.xml -p 80,443,8000,8080,8443
        cat medium-$FNAME.xml | aquatone -nmap
elif [ $1 == "large" ]; then
        nmap "${@:3}" -oX large-$FNAME.xml -p 80,81,443,591,2082,2087,2095,2096,3000,8000,8001,8008,8080,8083,8443,8834,8888
        cat large-$FNAME.xml | aquatone -nmap
elif [ $1 == "huge" ]; then
        nmap "${@:3}" -oX huge-$FNAME.xml -p 80,81,300,443,591,593,832,981,1010,1311,2082,2087,2095,2096,2480,3000,3128,3333,4243,4567,4711,4712,4993,5000,5104,5108,5800,6543,7000,7396,7474,8000,8001,8008,8014,8042,8069,8080,8081,8088,8090,8091,8118,8123,8172,8222,8243,8280,8281,8333,8443,8500,8834,8880,8888,8983,9000,9043,9060,9080,9090,9091,9200,9443,9800,9981,12443,16080,18091,18092,20720,28017
        cat huge-$FNAME.xml | aquatone -nmap
else
        echo "could not interpret port selection"
fi
