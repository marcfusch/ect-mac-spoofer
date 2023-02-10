# ect-mac-spoofer

This tool is used to get a random mac address, valid for connecting to "l'e-C Tablette" Wi-Fi networks with your mac.
## How to use:
It's very simple:
```
git clone https://github.com/marcfusch/ect-mac-spoofer/
cd ect-mac-spoofer
```
Then, you need to configure the script with your Atrium credentials.
You just need to modify the first two lines
```
nano mac.sh
```
Now to run the script:
```
chmod 755 mac.sh
./mac.sh
```
You will just need to enter your root password in order to change the mac address and connect to the Wi-Fi network.
