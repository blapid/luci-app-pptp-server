# luci-app-pptp-server
LuCI GUI App for configuring PPTP server (OpenWRT)

# Rationale
Setting up a VPN on OpenWRT routers can be intimidating to people who are not used to working with 
shells or to people who are afraid of messing up their setup.

This project's goal is to make an easy to use LuCI GUI application for configuring PPTP server.

Main features (goals for version 1.0):
* Enable/Disable the PPTP Server
* Set the local IP of the server
* Set the IP range for the clients
* Add/Remove clients
* Set clients' usernames, passwords and IP addresses

Advanced features may include setting up advanced ppp/pptpd options but I'm not sure about those yet.

I'm also interested in making a similar app for L2TP/IPSec and others.

# Status
This is still relatively new and in a WIP state.
Feel free to give it a try and let me know what you think!

# Disclaimer
PPTP is not a secure protocol. If you need a secure VPN, PPTP a recommended option.

See: https://en.wikipedia.org/wiki/Point-to-Point_Tunneling_Protocol#Security
