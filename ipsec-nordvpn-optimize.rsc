##########NORDVPN_credentials##########
:local vpnUser "Z1tYc6P4eu4Bz5butTff3myk"
:local vpnPass "JqCu35iGgcbwtbx41vjf37D1"

##############################
# 1. CẤU HÌNH CHUNG CHO USA #
##############################
/ip ipsec profile
add name=NordVPN_USA
/ip ipsec proposal
add name=NordVPN_USA pfs-group=none
/ip ipsec policy group
add name=NordVPN_USA
/ip ipsec policy
add group=NordVPN_USA proposal=NordVPN_USA src-address=0.0.0.0/0 dst-address=0.0.0.0/0 template=yes

:local usServers {"us9978.nordvpn.com";"us11607.nordvpn.com";"us8268.nordvpn.com";"us9986.nordvpn.com"}
:foreach s in=$usServers do={
    :local dotPos [:find $s "."]
    :local shortName [:pick $s 0 $dotPos]
    :local peerName ("NordVPN_USA_" . $shortName)
    
    /ip ipsec peer add name=$peerName address=$s exchange-mode=ike2 profile=NordVPN_USA
    /ip ipsec mode-config add name=$peerName responder=no
    /ip ipsec identity add peer=$peerName auth-method=eap eap-methods=eap-mschapv2 username=$vpnUser password=$vpnPass policy-template-group=NordVPN_USA generate-policy=port-strict mode-config=$peerName

    /ip firewall address-list add list=("vpn_usa_" . $shortName) comment=$peerName
    /ip ipsec mode-config set [find name=$peerName] src-address-list=("vpn_usa_" . $shortName)
}

###############################
# 2. CẤU HÌNH CHUNG CHO JAPAN #
###############################
/ip ipsec profile
add name=NordVPN_Japan
/ip ipsec proposal
add name=NordVPN_Japan pfs-group=none
/ip ipsec policy group
add name=NordVPN_Japan
/ip ipsec policy
add group=NordVPN_Japan proposal=NordVPN_Japan src-address=0.0.0.0/0 dst-address=0.0.0.0/0 template=yes

:local jpServers {"jp590.nordvpn.com";"jp621.nordvpn.com";"jp782.nordvpn.com"}
:foreach s in=$jpServers do={
    :local dotPos [:find $s "."]
    :local shortName [:pick $s 0 $dotPos]
    :local peerName ("NordVPN_Japan_" . $shortName)
    
    /ip ipsec peer add name=$peerName address=$s exchange-mode=ike2 profile=NordVPN_Japan
    /ip ipsec mode-config add name=$peerName responder=no
    /ip ipsec identity add peer=$peerName auth-method=eap eap-methods=eap-mschapv2 username=$vpnUser password=$vpnPass policy-template-group=NordVPN_Japan generate-policy=port-strict mode-config=$peerName

    /ip firewall address-list add list=("vpn_japan_" . $shortName) comment=$peerName
    /ip ipsec mode-config set [find name=$peerName] src-address-list=("vpn_japan_" . $shortName)
}

##################################
# 3. CẤU HÌNH CHUNG CHO HONGKONG #
##################################
/ip ipsec profile
add name=NordVPN_HongKong
/ip ipsec proposal
add name=NordVPN_HongKong pfs-group=none
/ip ipsec policy group
add name=NordVPN_HongKong
/ip ipsec policy
add group=NordVPN_HongKong proposal=NordVPN_HongKong src-address=0.0.0.0/0 dst-address=0.0.0.0/0 template=yes

:local hkServers {"hk287.nordvpn.com";"hk606.nordvpn.com";"hk607.nordvpn.com"}
:foreach s in=$hkServers do={
    :local dotPos [:find $s "."]
    :local shortName [:pick $s 0 $dotPos]
    :local peerName ("NordVPN_HongKong_" . $shortName)
    
    /ip ipsec peer add name=$peerName address=$s exchange-mode=ike2 profile=NordVPN_HongKong
    /ip ipsec mode-config add name=$peerName responder=no
    /ip ipsec identity add peer=$peerName auth-method=eap eap-methods=eap-mschapv2 username=$vpnUser password=$vpnPass policy-template-group=NordVPN_HongKong generate-policy=port-strict mode-config=$peerName

    /ip firewall address-list add list=("vpn_hongkong_" . $shortName) comment=$peerName
    /ip ipsec mode-config set [find name=$peerName] src-address-list=("vpn_hongkong_" . $shortName)
}
