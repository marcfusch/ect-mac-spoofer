#!/bin/bash

sudo /System/Library/PrivateFrameworks/Apple80211.framework/Resources/airport -z

interface=$(networksetup -listallhardwareports | awk '/Wi-Fi/{getline; print $2}')

hexchars="0123456789abcdef"
end=$( for i in {1..6} ; do echo -n ${hexchars:$(( $RANDOM % 16 )):1} ; done | sed -e 's/\(..\)/:\1/g' )
macadd="40:a1:08"$end

sudo ifconfig $interface ether $macadd
sudo networksetup -detectnewhardware

echo "Your new mac address is:" $macadd
