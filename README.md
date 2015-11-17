Tethering restriction bypass
============================


Version history
---------------

- 0.1 - Initial release
- 0.2 - Added automatic IP detection


Description
-----------

This will allow you to tether a mac to an iOS device in order to use its 3G/4G data connection.
It works even if Apple's "personal hotspot" function is not available, and also disguises the
traffic such that the carrier cannot detect that you're tethering.

Warning: if you have any configuration already in Proxifier, running setup.sh will erase it!

You have been warned!

Requires:

1. A computer running a linux-like OS somewhere on the internet that you can ssh to.

2. vSSH for iOS - http://www.velestar.com/Pages/VSSHIOSPage.aspx

3. Proxifier for mac v2.15 Beta 1 - https://www.proxifier.com/mac/


Known issues
------------

vSSH seems to crash intermittently.  Not sure why this is yet, but I will raise it with the author.

Update 17/11/15: I have received a response from Velestar about the intermittent crash, they are
looking into it.


Setup
-----

Create a vSSH profile on the iDevice that connects to the linux box via ssh.
Add a port forwarding rule to this profile with:

Type: Dynamic SOCKS proxying
Source:
 - Host: 127.0.0.1
 - Port: 8080

Accept all connections: Yes

Save this profile with a name like "tether".


Usage
-----

1. Create an ad-hoc wifi network on your mac.  I find channel 1 works best.

2. Connect the iDevice to the ad-hoc network.

3. Open vSSH on the phone and initiate the connection to your "tether" profile.

4. Run setup.sh on the mac with:

    ./setup.sh

It will automatically detect the IP address of the iDevice on the network and initiate the proxy.
Be patient as the iDevice will take a minute or so to self-assign its IP before it can be detected.

You should now be tethered.  Some apps may need to be restarted before they will work through the proxy.

Note that you will need to leave the iDevice running vSSH in order for the tunnel to stay active, so
the best thing to do is disable auto-lock in settings so the device won't go to sleep and suspend
the app.
