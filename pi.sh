#!/bin/bash
### CONFIGURE RASPBERRY PI ZERO 2 W ###

sudo apt update && sudo apt upgrade
sudo apt install git pip -y
pip3 install beautifulsoup4 lxml pandas

###########################################################
### Lowering power consumption ###
# https://www.cnx-software.com/2021/12/09/raspberry-pi-zero-2-w-power-consumption/

sudo vi /boot/config.txt

# Disable audio L53
dtparam=audio=off

# Disable camera L56
camera_auto_detect=0
 
# Disable display L59
display_auto_detect=0

# Disable HDMI
raspi-config
'Advanced options -> GL driver'
# Install whatever packages are needed, then select the following option:
'G1 Legacy'

sudo vi /etc/rc.local
# Add the following line before exit 0:
/usr/bin/tvservice -o

###########################################################
### Installing pihole ###
# https://www.crosstalksolutions.com/the-worlds-greatest-pi-hole-and-unbound-tutorial-2023/

# Set static IP for the rpi

curl -sSL https://install.pi-hole.net | sudo bash
# Go throught the installation process

# Change the admin webpage password:
pihole -a -p

# Go to the admin webpage on your browser
http://[static IP]/admin

# Add more domains to adlist
https://firebog.net/
# Then go to Tools > Update Gravity in order to update the list

# Rate limited
sudo vi /etc/pihole/pihole-FTL.conf
# Paste the following line to disable rate limit
RATE_LIMIT=0/0

# Set unbound
sudo apt install unboud -y
sudo vi /etc/unbound/unbound.conf.d/pi-hole.conf
# Paste the following:
'
server:
# If no logfile is specified, syslog is used
# logfile: "/var/log/unbound/unbound.log"
verbosity: 0

interface: 127.0.0.1
port: 5335
do-ip4: yes
do-udp: yes
do-tcp: yes

# May be set to yes if you have IPv6 connectivity
do-ip6: no

# You want to leave this to no unless you have *native* IPv6. With 6to4 and
# Terredo tunnels your web browser should favor IPv4 for the same reasons
prefer-ip6: no

# Use this only when you downloaded the list of primary root servers!
# If you use the default dns-root-data package, unbound will find it automatically
#root-hints: "/var/lib/unbound/root.hints"

# Trust glue only if it is within the servers authority
harden-glue: yes

# Require DNSSEC data for trust-anchored zones, if such data is absent, the zone becomes BOGUS
harden-dnssec-stripped: yes

# Dont use Capitalization randomization as it known to cause DNSSEC issues sometimes
# see https://discourse.pi-hole.net/t/unbound-stubby-or-dnscrypt-proxy/9378 for further details
use-caps-for-id: no

# Reduce EDNS reassembly buffer size.
# IP fragmentation is unreliable on the Internet today, and can cause
# transmission failures when large DNS messages are sent via UDP. Even
# when fragmentation does work, it may not be secure; it is theoretically
# possible to spoof parts of a fragmented DNS message, without easy
# detection at the receiving end. Recently, there was an excellent study
# >>> Defragmenting DNS - Determining the optimal maximum UDP response size for DNS <<<
# by Axel Koolhaas, and Tjeerd Slokker (https://indico.dns-oarc.net/event/36/contributions/776/)
# in collaboration with NLnet Labs explored DNS using real world data from the
# the RIPE Atlas probes and the researchers suggested different values for
# IPv4 and IPv6 and in different scenarios. They advise that servers should
# be configured to limit DNS messages sent over UDP to a size that will not
# trigger fragmentation on typical network links. DNS servers can switch
# from UDP to TCP when a DNS response is too big to fit in this limited
# buffer size. This value has also been suggested in DNS Flag Day 2020.
edns-buffer-size: 1232

# Perform prefetching of close to expired message cache entries
# This only applies to domains that have been frequently queried
prefetch: yes

# One thread should be sufficient, can be increased on beefy machines. In reality for most users running on small networks or on a single machine, it should be unnecessary to seek performance enhancement by increasing num-threads above 1.
num-threads: 1

# Ensure kernel buffer is large enough to not lose messages in traffic spikes
so-rcvbuf: 1m

# Ensure privacy of local IP ranges
private-address: 192.168.0.0/16
private-address: 169.254.0.0/16
private-address: 172.16.0.0/12
private-address: 10.0.0.0/8
private-address: fd00::/8
private-address: fe80::/10
'
sudo service unbound restart
sudo service unbound status # Should say active (running)
# Test with
dig google.com @127.0.0.1 -p 5335
# On the 4th line, next to status it should be NOERROR
    # If it says SERVERR then:
    sudo vi /etc/resolv.conf
    # Comment the last line, which should be
    # unbound_conf=/etc/unbound/unbound.conf.d/resolvconf_resolvers.conf
    sudo rm /etc/unbound/unbound_conf.d/resolvconf_resolvers.conf
    sudo service unbound restart
    # Test again
    dig google.com @127.0.0.1 -p 5335

# Go to the admin webpage
'Side bar -> Settings -> DNS ->[clear upstream dns servers -> add Custom 1(IPv4) as [127.0.0.1#5335] -> save'

### Pihole log file ###
vim /var/log/pihole.log
