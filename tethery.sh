#!/bin/bash
if [ "$1" == "-i" ] ; then
    if [ "$2" == "" ] ; then
        echo "-i needs a parameter, eg: -i en0"
        exit 1
    fi
    wifi_interface="$2"
else
    wifi_interface=`/usr/sbin/networksetup -listallhardwareports |grep -A1 -i 'Wi-Fi' |tail -n1 |cut -d ' ' -f2`
fi

if [ "$wifi_interface" == "" ] ; then
    echo
    echo "Unable to detect your wifi interface."
    echo
    echo "You can specify it manually with -i, eg:"
    echo
    echo "$0 -i en0"
    echo
    exit 1
fi

checkif=`/sbin/ifconfig "$wifi_interface" 2>/dev/null`

if [ "$checkif" == "" ] ; then
    echo "interface $wifi_interface does not exist"
    exit 1
fi

echo -n "Waiting for local self-assign IP... "

while [ "$localip" == "" ] ; do
    localip=`/sbin/ifconfig $wifi_interface |grep 'inet ' |xargs -L1 |cut -d ' ' -f2`
    sleep 1
done

echo "$localip"

echo -n "Waiting for iDevice... "

while [ "$deviceip" == "" ] ; do
    deviceip=`ping -c16 -t2 169.254.255.255 2>/dev/null |grep 'bytes from' |grep -v "$localip" |tail -n1 |cut -d ' ' -f4 |cut -d ':' -f1`
    sleep 1
done

echo "$deviceip"

killall Proxifier 1>/dev/null 2>/dev/null
sleep 2
cp proxifier.template ~/Library/Application\ Support/Proxifier/Profiles/default.ppx
sed -i '' "s/{{PROXY_ADDRESS}}/$deviceip/g" ~/Library/Application\ Support/Proxifier/Profiles/default.ppx
open /Applications/Proxifier.app
echo
echo "Proxy is set up.  You may need to restart some applications to make them work."
echo
