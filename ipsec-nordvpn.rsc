#2. Thiết lập cấu hình IPsec cho VPN Hoa Kỳ:
/ip ipsec profile
add name=NordVPN_USA
/ip ipsec proposal
add name=NordVPN_USA pfs-group=none
/ip ipsec policy group
add name=NordVPN_USA
/ip ipsec policy
add group=NordVPN_USA proposal=NordVPN_USA src-address=0.0.0.0/0 dst-address=0.0.0.0/0 template=yes
/ip ipsec peer
add name=NordVPN_USA address=us8255.nordvpn.com exchange-mode=ike2 profile=NordVPN_USA
/ip ipsec mode-config
add name=NordVPN_USA responder=no
/ip ipsec identity
add peer=NordVPN_USA auth-method=eap eap-methods=eap-mschapv2 username=Z1tYc6P4eu4Bz5butTff3myk password=JqCu35iGgcbwtbx41vjf37D1 policy-template-group=NordVPN_USA generate-policy=port-strict mode-config=NordVPN_USA

#3. Thiết lập cấu hình IPsec cho VPN Nhật Bản:
/ip ipsec profile
add name=NordVPN_Japan
/ip ipsec proposal
add name=NordVPN_Japan pfs-group=none
/ip ipsec policy group
add name=NordVPN_Japan
/ip ipsec policy
add group=NordVPN_Japan proposal=NordVPN_Japan src-address=0.0.0.0/0 dst-address=0.0.0.0/0 template=yes
/ip ipsec peer
add name=NordVPN_Japan address=jp605.nordvpn.com exchange-mode=ike2 profile=NordVPN_Japan
/ip ipsec mode-config
add name=NordVPN_Japan responder=no
/ip ipsec identity
add peer=NordVPN_Japan auth-method=eap eap-methods=eap-mschapv2 username=Z1tYc6P4eu4Bz5butTff3myk password=JqCu35iGgcbwtbx41vjf37D1 policy-template-group=NordVPN_Japan generate-policy=port-strict mode-config=NordVPN_Japan

#4. Thiết lập cấu hình IPsec cho VPN Hồng Kông:
/ip ipsec profile
add name=NordVPN_HongKong
/ip ipsec proposal
add name=NordVPN_HongKong pfs-group=none
/ip ipsec policy group
add name=NordVPN_HongKong
/ip ipsec policy
add group=NordVPN_HongKong proposal=NordVPN_HongKong src-address=0.0.0.0/0 dst-address=0.0.0.0/0 template=yes
/ip ipsec peer
add name=NordVPN_HongKong address=hk287.nordvpn.com exchange-mode=ike2 profile=NordVPN_HongKong
/ip ipsec mode-config
add name=NordVPN_HongKong responder=no
/ip ipsec identity
add peer=NordVPN_HongKong auth-method=eap eap-methods=eap-mschapv2 username=Z1tYc6P4eu4Bz5butTff3myk password=JqCu35iGgcbwtbx41vjf37D1 policy-template-group=NordVPN_HongKong generate-policy=port-strict mode-config=NordVPN_HongKong

#5. Tạo Address List cho từng nhóm IP:
/ip firewall address-list
add list=vpn_usa
/ip firewall address-list
add list=vpn_usa
/ip firewall address-list
add list=vpn_japan
/ip firewall address-list
add list=vpn_hongkong
#6. Định cấu hình Mode Config để sử dụng Address List:
/ip ipsec mode-config
set [find name=NordVPN_USA] src-address-list=vpn_usa
/ip ipsec mode-config
set [find name=NordVPN_Japan] src-address-list=vpn_japan
/ip ipsec mode-config
set [find name=NordVPN_HongKong] src-address-list=vpn_hongkong
#7. Định cấu hình NAT (Network Address Translation):
/ip firewall nat
add chain=srcnat src-address-list=vpn_usa action=masquerade out-interface=ipsec-tunnel-usa
add chain=srcnat src-address-list=vpn_japan action=masquerade out-interface=ipsec-tunnel-japan
add chain=srcnat src-address-list=vpn_hongkong action=masquerade out-interface=ipsec-tunnel-hongkong
