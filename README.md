RaspberryPortal
===============

1. Configure the RaspberryPi thusly:
1. Connect the onboard port (eth0) to your router.
1. Connect a USB ethernet adapter to one of the USB ports. (eth1).
1. Connect the USB ethernet port to the relevant uplink port on your wireless access point.
1. Load the software from the github repository.
1. Run bundle install
1. Run bin/configure.sh
1. Run bin/start_routing.sh
1. Run ruby redirect.rb

Any traffic entering the RaspberryPortal without a known mac address in the IPtables cache will be redirected to the local webserver

This will then show the user a (customisable) webpage with a Paypal "Donate" button which will redirect them to Paypal to make a donation to charity.

They can also skip donation.

After either of these events, they will be redirected to where they came from, and their internet access is now unrestricted.

This currently is very new code, and not really suitable for anything other than a proof of concept.  
We proved however that over the course of a hackathon it's possible to a) turn a Raspberry Pi into a router, and b) make this router run a ruby web application which uses paypal for charitable donations.

Made with the help of [https://github.com/cbetta/], at the Paypal Charity Hack 2012.

