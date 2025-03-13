:local vpnList {"fpt.han01"; "fpt.han02"; "fpt.han03"; "fpt.han04"; "fpt.han05"; "fpt.han06"; "fpt.han07"; "fpt.han08"; "fpt.han09"; "fpt.han10"; "fpt.han11"; "fpt.han12"; "fpt.han13"; "fpt.han14"; "fpt.han15"; "fpt.han16"; "fpt.han17"; "fpt.han18"; "fpt.han19"; "fpt.han20"; "fpt.han21"; "fpt.han22"; "fpt.han23"; "fpt.han24"; "fpt.han25"; "fpt.han26"; "fpt.han27"; "fpt.han28"; "fpt.han29"; "fpt.han30"; "fpt.han31"; "fpt.sgn001"; "fpt.sgn002"; "fpt.sgn003"; "fpt.sgn004"; "fpt.sgn005"; "fpt.sgn006"; "fpt.sgn007"; "fpt.sgn008"; "fpt.sgn009"; "fpt.sgn010"; "fpt.sgn011"; "fpt.sgn012"; "fpt.sgn013"; "fpt.sgn014"; "fpt.sgn015"; "fpt.sgn016"; "fpt.sgn017"; "fpt.sgn018"; "fpt.sgn019"; "fpt.sgn021"; "fpt.sgn022"; "hongkong-02"; "hongkong-04"; "hongkong-05"; "hongkong-07"; "japan-1"; "korea-1"; "sing-01"; "sing-02"; "sing-03"; "sing-04"; "sing-05"; "sing-06"; "sing-07"; "sing-08"; "taiwan-1"; "us-01"; "viettel-han-01"; "vnpt-han01"; "vnpt-han02"; "vnpt-han03"; "vnpt-han04"; "vnpt-han05"; "vnpt-han06"; "vnpt-sgn01"; "vnpt-sgn02"; "vnpt-sgn03"; "vnpt-sgn04"}

:local portStart 13210
:local counter 0

:foreach vpn in=$vpnList do={
    :set counter ($counter + 1)
    :local listenPort ($portStart + $counter - 1)
    
    # 1. Tạo interface WireGuard với private key và listen-port
    /interface wireguard add name=$vpn private-key="WObgJlT9XOUKpb/Guct9ICN5I8ETHGKvo4Vv6rCr5E0=" listen-port=$listenPort
    
    # 2. Tạo peer với public key, preshared-key, allowed-address, endpoint và persistent-keepalive
    /interface wireguard peers add interface=$vpn public-key="+DH5VO65RaVbujNJLtE25ZKLuVQbFp5gJbxuXBTsrGw=" preshared-key="HlCnkgX4SeB25YoXy8yfPhyJpeOJOGfa4X+ydb2fhrc=" allowed-address="0.0.0.0/0, ::/0" endpoint-address=($vpn . ".truy.in") endpoint-port=51820 persistent-keepalive=15
    
    # 3. Gán địa chỉ IP cho interface
    /ip address add address="10.7.22.142/32" interface=$vpn
    
    # 4. Tạo routing table với tên "to-<vpn>"
    /routing table add name=("to-" . $vpn) fib
    
    # 5. Tạo route với gateway là interface WireGuard
    /ip route add gateway=$vpn routing-table=("to-" . $vpn)
    
    # 6. Tạo firewall NAT với out-interface là interface WireGuard
    /ip firewall nat add chain=srcnat out-interface=$vpn action=masquerade
    
    # 7. Tạo address list với tên "go-<vpn>"
    /ip firewall address-list add list=("go-" . $vpn)
    
    # 8. Tạo firewall mangle để định tuyến các gói tin từ address list qua routing table
    /ip firewall mangle add chain=prerouting src-address-list=("go-" . $vpn) action=mark-routing new-routing-mark=("to-" . $vpn)
}

:put "Đã tạo xong cấu hình VPN từ danh sách đã cho!"
