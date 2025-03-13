/ip/firewall/mangle/add chain=forward protocol=tcp tcp-flags=syn action=change-mss new-mss=clamp-to-pmtu passthrough=yes
:for i from=1 to=250 do={
    :local name ("wg" . $i)
    :local addressList ("go-" . $name)
    :local routingTable ("to-" . $name)
    :local listenPort ($i + 13209)   ;# Với i=1: listenPort = 13210

    # 1. Tạo interface WireGuard với private key và listen-port
    /interface wireguard add name=$name private-key="ML35+zx8Ke9zdEHF+TgUDC4be2lVWz6fRL2Vu/wVVWc=" listen-port=$listenPort

    # 2. Tạo peer với public key, allowed address, endpoint address, endpoint port cố định
    /interface wireguard peers add interface=$name public-key="YJSjrc/WWOjQUyUi4iYcHb7LsWWoCY+2fK8/8VtC/BY=" allowed-address="0.0.0.0/0" endpoint-address=jp-tok.prod.surfshark.com endpoint-port=51820

    # 3. Gán địa chỉ IP cố định cho interface
    /ip address add address="10.14.0.2/16" interface=$name

    # 4. Tạo routing table FIB với tên "to-<tên_interface>"
    /routing table add name=$routingTable fib

    # 5. Tạo route với gateway là interface WireGuard
    /ip route add gateway=$name routing-table=$routingTable

    # 6. Tạo firewall NAT với out-interface là interface WireGuard
    /ip firewall nat add chain=srcnat out-interface=$name action=masquerade

    # 7. Tạo address list với tên "go-<tên_interface>"
    /ip firewall address-list add list=$addressList

    # 8. Tạo IP Firewall Mangle để định tuyến các gói tin từ address list qua routing table
    /ip firewall mangle add chain=prerouting src-address-list=$addressList action=mark-routing new-routing-mark=$routingTable passthrough=no
}
