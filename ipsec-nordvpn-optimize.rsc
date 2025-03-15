# Define common profile and proposal for all regions
/ip ipsec profile
add name=NordVPN_Profile

/ip ipsec proposal
add name=NordVPN_Proposal pfs-group=none

# Define policy groups and policy templates for each region
/ip ipsec policy group
add name=NordVPN_USA
add name=NordVPN_Japan
add name=NordVPN_HongKong

/ip ipsec policy
add group=NordVPN_USA proposal=NordVPN_Proposal template=yes src-address=0.0.0.0/0 dst-address=0.0.0.0/0
add group=NordVPN_Japan proposal=NordVPN_Proposal template=yes src-address=0.0.0.0/0 dst-address=0.0.0.0/0
add group=NordVPN_HongKong proposal=NordVPN_Proposal template=yes src-address=0.0.0.0/0 dst-address=0.0.0.0/0

# Define server arrays for each region
:local usServers {"us9978.nordvpn.com";"us11607.nordvpn.com";"us8268.nordvpn.com";"us9986.nordvpn.com"}
:local jpServers {"jp590.nordvpn.com";"jp621.nordvpn.com";"jp782.nordvpn.com"}
:local hkServers {"hk287.nordvpn.com";"hk606.nordvpn.com";"hk607.nordvpn.com"}

# Add peers, mode-configs, and identities for USA
:foreach s in=$usServers do={
    /ip ipsec peer add \
        name=("NordVPN_USA_" . $s) \
        address=$s \
        exchange-mode=ike2 \
        profile=NordVPN_Profile
    
    /ip ipsec mode-config add \
        name=("NordVPN_USA_" . $s) \
        responder=no
    
    /ip ipsec identity add \
        peer=("NordVPN_USA_" . $s) \
        auth-method=eap \
        eap-methods=eap-mschapv2 \
        username="YOUR_NORDVPN_USERNAME" \
        password="YOUR_NORDVPN_PASSWORD" \
        policy-template-group=NordVPN_USA \
        generate-policy=port-strict \
        mode-config=("NordVPN_USA_" . $s)
}

# Add peers, mode-configs, and identities for Japan
:foreach s in=$jpServers do={
    /ip ipsec peer add \
        name=("NordVPN_Japan_" . $s) \
        address=$s \
        exchange-mode=ike2 \
        profile=NordVPN_Profile
    
    /ip ipsec mode-config add \
        name=("NordVPN_Japan_" . $s) \
        responder=no
    
    /ip ipsec identity add \
        peer=("NordVPN_Japan_" . $s) \
        auth-method=eap \
        eap-methods=eap-mschapv2 \
        username="YOUR_NORDVPN_USERNAME" \
        password="YOUR_NORDVPN_PASSWORD" \
        policy-template-group=NordVPN_Japan \
        generate-policy=port-strict \
        mode-config=("NordVPN_Japan_" . $s)
}

# Add peers, mode-configs, and identities for Hong Kong
:foreach s in=$hkServers do={
    /ip ipsec peer add \
        name=("NordVPN_HongKong_" . $s) \
        address=$s \
        exchange-mode=ike2 \
        profile=NordVPN_Profile
    
    /ip ipsec mode-config add \
        name=("NordVPN_HongKong_" . $s) \
        responder=no
    
    /ip ipsec identity add \
        peer=("NordVPN_HongKong_" . $s) \
        auth-method=eap \
        eap-methods=eap-mschapv2 \
        username="YOUR_NORDVPN_USERNAME" \
        password="YOUR_NORDVPN_PASSWORD" \
        policy-template-group=NordVPN_HongKong \
        generate-policy=port-strict \
        mode-config=("NordVPN_HongKong_" . $s)
}

# Create address lists for LAN IPs to route through each VPN
/ip firewall address-list
add list=vpn_usa
add list=vpn_japan
add list=vpn_hongkong
# Note: Manually add LAN IPs to these lists (e.g., 192.168.1.10 to vpn_usa)

# Configure NAT rules (adjust out-interface as needed)
/ip firewall nat
add chain=srcnat src-address-list=vpn_usa action=masquerade out-interface=ipsec-tunnel-usa
add chain=srcnat src-address-list=vpn_japan action=masquerade out-interface=ipsec-tunnel-japan
add chain=srcnat src-address-list=vpn_hongkong action=masquerade out-interface=ipsec-tunnel-hongkong
# Note: out-interface names are placeholders; replace with actual tunnel interface names
