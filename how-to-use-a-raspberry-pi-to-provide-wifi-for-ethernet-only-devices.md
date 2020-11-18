Source: https://gist.github.com/Konamiman/110adcc485b372f1aff000b4180e2e10

# How to use a Raspberry Pi to provide WiFi for Ethernet-only devices

Here I'll explain how to configure a Raspberry Pi to act as a "WiFi dongle" for TCP/IP capable but Ethernet-only devices. For my tests I have used a Raspberry Pi Zero W with an OTG USB Ethernet adapter (4€ in eBay), but any other model of Pi should work as long as it has Ethernet and WiFi. You'll need a tool to connect to the Pi via SSH (I recommend [MobaXTerm](https://mobaxterm.mobatek.net) if you use Windows).

I'm sure that someone has done this before and has published it somewhere, but I weren't able to find it. What I did find was [this article in Raspberry Pi HQ about how to turn a Pi into a WiFi router](https://raspberrypihq.com/how-to-turn-a-raspberry-pi-into-a-wifi-router), but what this article explains is how to turn a Pi connected to the router via Ethernet into a WiFi access point for other devices; we need exactly the opposite, but I used the information in that article as a starting point, modifying what I needed.
<br/><br/>

## Step 0: Configure the Pi

I'm assuming that your Raspberry Pi is up and running Raspbian, with the WiFi already configured. In order to configure my Pi Zero I followed [this tutorial in Desertbot for headless setup using Windows](https://desertbot.io/blog/headless-pi-zero-w-wifi-setup-windows), which can be summarized as:

1. [Download the Raspbian image](https://www.raspberrypi.org/downloads/raspbian/) (Raspbian Lite is fine)

2. Flash the image file in the SD card using [balena Etcher](https://www.balena.io/etcher)

3. Reinsert the SD card in your computer, Windows will create a few drive letters and tell you that all are unformatted but one. In that one create an empty file named `ssh` (withot any extension), and a file named `wpa_supplicant.conf` with the details of your WiFi access point as follows:

```
country=<ISO code of your country>
ctrl_interface=DIR=/var/run/wpa_supplicant GROUP=netdev
update_config=1

network={
  scan_ssid=1
  ssid="<the name of your WiFi network>"
  psk="<the password for your WiFi network>"
}
```

4. Insert the SD card in your Pi and let it boot. Wait one minute or so.

5. If you install [bonjour](https://support.apple.com/kb/DL999?locale=en_US) you'll be able to find your Pi by the name `raspberrypi.local`. Otherwise you need to get the IP that the Pi got by using a network scanner (there are plenty for Android, for example).

6. If everything went well you should now be able to SSH to your Pi using `pi` as the user name and `raspberry` as the password. Hooray!

The next steps are to be done via the SSH prompt directly in the Pi. To edit files text you can use the `pico` editor by running `sudo pico filename`.
<br/><br/>


## Step 1: Setup DHCP

First we need to configure the DHCP client so that the Ethernet port of the Pi gets a fixed IP address and network mask. Edit the `/etc/dhcp/dhcpd.conf` file and add the following content to it:

```
interface eth0
static ip_address=192.168.34.1/24
```

We'll use the 192.168.34.x as the IPs range for the network attached to the Ethernet port. And why the 34, you might ask? It's [for important historical reasons](https://www.konamiman.com/mato34/index-e.html).

Next, we need to configure a DHCP server so that the device connected to the Ethernet port gets its IP configuration by using itw oen DHCP client. First, install the DHCP server:

```
sudo apt-get install isc-dhcp-server
```

Then edit the `/etc/dhcp/dhcpd.conf` file by adding the following:

```
authoritative;
subnet 192.168.34.0 netmask 255.255.255.0 {
 range 192.168.34.10 192.168.34.250;
 option broadcast-address 192.168.34.255;
 option routers 192.168.34.1;
 default-lease-time 600;
 max-lease-time 7200;
 option domain-name "local-network";
 option domain-name-servers 8.8.8.8, 8.8.4.4;
}
```

Now edit the `/etc/default/isc-dhcp-server` file and add set the line starting with `INTERFACESv4` as follows:

```
INTERFACESv4="eth0"
```

And with this, the DHCP configuration is finished. To start the DHCP server run this: `service isc-dhcp-server start`.
<br/><br/>


## Step 2: configure IP forwarding

Now we need to configure IP forwarding: we want all the network traffic coming from the Ethernet port to be forwarded to the WiFi network, and viceversa. These commands will do the trick:

```
sudo iptables -t nat -A POSTROUTING -o wlan0 -j MASQUERADE
sudo iptables -A FORWARD -i wlan0 -o eth0 -m state --state RELATED,ESTABLISHED -j ACCEPT
sudo iptables -A FORWARD -i eht0 -o wlan0 -j ACCEPT
```

Also we need to add the following at the end of the `/etc/sysctl.conf` file in order to actually enable IP forwarding:

```
net.ipv4.ip_forward=1
```
<br/><br/>


## Step 3: Set the WiFi network as the main route

A problem I had the first time I played around with my Pi + the Ethernet adapter is that Raspbian was using the Ethenet port for the default entry in the IP routing table. This of course doesn't work, since the outside world is visible in the WiFi network, not in the Ethernet port where there's just a poor MSX sitting.

Eventually I flashed Raspbian again to have a fresh start after having messed things around... and this time Raspbian had configured, correctly, the wlan0 interface as the one for the default entry in the IP routing table.

So just in case, run these commands. If the interface for the main entry is wlan0, nothing will happen; otherwise, wlan0 will be set as such:

```
DEFAULT_IFACE=`route -n | grep -E "^0.0.0.0 .+UG" | awk '{print $8}'`
if [ "$DEFAULT_IFACE" != "wlan0" ]
then
  GW=`route -n | grep -E "^0.0.0.0 .+UG .+wlan0$" | awk '{print $2}'`
  echo Setting default route to wlan0 via $GW
  sudo route del default $DEFAULT_IFACE
  sudo route add default gw $GW wlan0
fi
```
<br/><br/>


## Step 4: Set everything at boot time

The last step is to set Raspbian to configure all of this automatically when the Pi boots. We'll do this with crontab.

First, create a new file named `~/router` with the following contents (the `echo` statements aren't necessary, but may be useful for testing):

```
echo Starting DHCP server
service isc-dhcp-server start

echo Setting NAT routing
iptables -t nat -A POSTROUTING -o wlan0 -j MASQUERADE
iptables -A FORWARD -i wlan0 -o eth0 -m state --state RELATED,ESTABLISHED -j ACCEPT
iptables -A FORWARD -i eht0 -o wlan0 -j ACCEPT

DEFAULT_IFACE=`route -n | grep -E "^0.0.0.0 .+UG" | awk '{print $8}'`
if [ "$DEFAULT_IFACE" != "wlan0" ]
then
  GW=`route -n | grep -E "^0.0.0.0 .+UG .+wlan0$" | awk '{print $2}'`
  echo Setting default route to wlan0 via $GW
  route del default $DEFAULT_IFACE
  route add default gw $GW wlan0
fi
```

Don't forget to make the file executable with `chmod +x ~/router` after creating it.

Now run `crontab -e` and when the text editor opens add the following:

```
@reboot sudo /home/pi/router
```
<br/><br/>


## Step 5: Try it!

Reboot your Pi and connect its Ethernet port to your Ethernet-only device. If everything goes as planned now your device has an IP address in the range 192.168.34.x and has Internet access thanks the Pi's WiFi interface. Celebrate and party!
