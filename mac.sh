#!/bin/bash

#Change these two lines to your Atrium login credentials
###

login="NAME.LASTNAME"
password="PASSWORD"

###

sudo /System/Library/PrivateFrameworks/Apple80211.framework/Resources/airport -z

interface=$(networksetup -listallhardwareports | awk '/Wi-Fi/{getline; print $2}')

hexchars="0123456789abcdef"
end=$( for i in {1..6} ; do echo -n ${hexchars:$(( $RANDOM % 16 )):1} ; done | sed -e 's/\(..\)/:\1/g' )
macadd="40:a1:08"$end

sudo ifconfig $interface ether $macadd
networksetup -detectnewhardware

echo "Your new mac address is:" $macadd

echo "Connecting to Wi-Fi network"
networksetup -setairportnetwork $interface "l'e-C Tablette"
ssid=""
t=0

while [[ $ssid != "l'e-C" ]]; do
  ssid=$(/System/Library/PrivateFrameworks/Apple80211.framework/Resources/airport -I | awk '/ SSID:/ {print $2}')
  t=$((t + 1))
  if [[ $t > 40 ]]; then
    echo "Login failed, please check your network connection"
    exit 1
  fi
  sleep 0.5
done

echo "Connected to Wi-Fi network"
echo "Getting Auth token, please close the auth window..." 
token=""
url="http://authentification.realyce.fr:1000/fgtauth"

while [[ $(echo $token | cut -d '?' -f 1) != $url ]]; do
  token=$(curl -Ls -o /dev/null -w %{url_effective} http://google.com )
  sleep 0.5
done;

echo "Auth grabbed "

info=$(echo $token | cut -d '?' -f 2)

echo "Logging in..."

response="$(curl "$url" \
  -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9' \
  -H 'Accept-Language: fr-FR,fr;q=0.9,en-US;q=0.8,en;q=0.7' \
  -H 'Cache-Control: max-age=0' \
  -H 'Connection: keep-alive' \
  -H 'Content-Type: application/x-www-form-urlencoded' \
  -H "Origin: $url" \
  -H "Referer: $token" \
  -H 'Upgrade-Insecure-Requests: 1' \
  -H 'Mozilla/5.0 (Linux; Android 9; cp3705A) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/78.0.3904.90 Mobile Safari/537.36' \
  --data-raw "4Tredir=http%3A%2F%2Fwww.gstatic.com%2Fgenerate_204&magic=$info&username=$login&password=$password" \
  --compressed \
  --insecure \
  2>/dev/null)"

if [[ "$response" == *"keepalive"* ]]; then
  echo "Auth successful. You can now browse the web"
else
  echo "Auth failed, please check your credentials and run the script again"
fi
