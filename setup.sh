#!/bin/bash
localip=`/sbin/ifconfig en0 |grep 'inet ' |xargs -L1 |cut -d ' ' -f2`

echo "Waiting for iDevice..."
while :
do
    deviceip=`ping -c10 -t2 169.254.255.255 |grep 'bytes from' |grep -v "$localip" |tail -n1 |cut -d ' ' -f4 |cut -d ':' -f1`

    if [ "$deviceip" != "" ] ; then
        break
    fi
done

killall Proxifier 1>/dev/null 2>/dev/null
sleep 2
cp proxifier.template ~/Library/Application\ Support/Proxifier/Profiles/default.ppx
sed -i '' "s/{{PROXY_ADDRESS}}/$deviceip/g" ~/Library/Application\ Support/Proxifier/Profiles/default.ppx
open /Applications/Proxifier.app
echo
echo "Proxy is set up.  You may need to restart some applications to make them work."
echo
