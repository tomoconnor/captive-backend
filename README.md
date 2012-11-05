CharityWifi
===============

CharityWifi: Integrating a charitable donation into wireless hotspot captive portal.
------------------------------------------------------------------------------------
For the [Paypal CharityHack 2012](http://charityhack.org/), [Cristiano Betta](https://github.com/cbetta/) and myself created a hardware hack using a free [Raspberry Pi](http://www.raspberrypi.org/) that were prizes for the first 40 people through the doors.

So Cristiano’s original idea was lacking in the exact technical implementation, but we basically knew what the  plan was.  

Once we’d got a 2GB SD card flashed with [Raspbian-wheezy](http://www.raspberrypi.org/downloads), which is basically just Debian for armv6, we had to go and find a TV with hdmi to do the initial setting.

### Basic Configuration Steps:

1. Connect the onboard port (eth0) to your router.
1. Connect a USB ethernet adapter to one of the USB ports. (eth1).
1. Connect the USB ethernet port to the relevant uplink port on your wireless access point.
1. Load the software from the github repository.
1. Run bundle install
1. Run bin/configure.sh (might not be required)
1. Run bin/start_routing.sh
1. Run ruby redirect.rb

#### eth0 (onboard)
IP address DHCP

#### eth1 (USB NIC)
IP address 172.16.254.1/24

Then ssh in on the 172.16.254.1 address, and sudo up. 
And enable IP Forwarding in the kernel:
    echo 1 > /proc/sys/net/ipv4/ip_forward

and then
in `/etc/sysctl.conf`
    net.ipv4.ip_forward = 1


So at this point, the next step is to configure NAT on the interface, so that the router is able to actually overload traffic onto the lone IP address.

    sudo iptables -t nat --flush
    sudo iptables --table nat --append POSTROUTING --out-interface eth0 -j MASQUERADE
    sudo iptables --append FORWARD --in-interface eth1 -j ACCEPT

At this point, all traffic coming into the Pi on eth1 can be sent out to eth0 and out onto the internet.

Let’s have a think about the code now. As Cristiano writes Ruby, and I’m learning Ruby, that was what we chose to write in. 

in bin/start_routing.sh there’s a bunch of iptables rules which set up the routing so that 
1. All DHCP and DNS traffic is allowed out.  
1. All traffic on port 80 gets redirected to the Pi’s IP onto port 4567 (the ruby port for the ruby app) initially 
1. A new table called NET gets created, which is where we’ll dump the traffic from known clients into, and this’ll go straight to the internet.

The next step is to start the ruby application, which will intercept HTTP requests to *anywhere*, and then redirect them to a Landing Page 

![Landing Page](https://raw.github.com/tomoconnor/captive-backend/master/site/landing_page.jpg), 

Which will then redirect to the Paypal payment gateway 

![Payment Gateway](https://raw.github.com/tomoconnor/captive-backend/master/site/paypal_login.jpg) 

Where the user will actually pay for their donation.  All through this process, they don’t have to make one, they can cancel, and still surf for free.

![Paypal Review Screen](https://raw.github.com/tomoconnor/captive-backend/master/site/review.jpg)

The rest of the process just follows the traditional Paypal review/complete process.

![Paypal process completed](https://raw.github.com/tomoconnor/captive-backend/master/site/complete.jpg)


The paypal return URL (when you click "Continue surfing") will mean that you’ll get redirected to where you expected to go to initially, after you hit our landing page.



Things I found out:
-------------------
1. Ruby isn’t installed by default on the ‘Pi (Python is, however).
1. “Building native extensions.. This may take a while.”  No kidding. 
3. Intercepting port 80 traffic and redirecting users is.. Cheeky.  It doesn’t currently work with https, as that’s a whole bunch of SSL i didn’t have time to contemplate.
4. If you intercept a user’s traffic, make sure you forcibly close the connection with HTTP headers, or you’ll never get out of the loop.
5. Related to 4, You’ve gotta clear conntrack information for established connections, otherwise again, you’ll never break out.
6. Programming at 3AM is a bitch.
7. Serverfault *always* comes through. 
8. Learning Ruby is insanely easy with StackOverflow with a guide.  Seriously, there’s like 10 lines of code that I wrote and each line is the answer to a different SO question.
9. The only way to get a user’s mac address is to shell out to arp. 
10. I *really* need sleep.

CharityWifi won 2nd Place
-------------------------
![Winning a prize of a Samsung Galaxy S3 each](http://yfrog.com/scaled/landing/875/e0rik.jpg)

We won 2nd place, and apparently created "a very innovative hack" said one of the judges.


