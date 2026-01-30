Content-Type: multipart/mixed; boundary="==AWS=="
MIME-Version: 1.0

--==AWS==
Content-Type: text/x-shellscript; charset="us-ascii"
MIME-Version: 1.0

config system global
set hostname ${fgt_id}
end
config system interface
edit port1                            
set alias DATA
set mode static
set ip ${fgt_data_ip}
set allowaccess ping https ssh
set mtu-override enable
set mtu 9001
next
edit port2
set alias HEARTBEAT
set mode static
set ip ${fgt_heartbeat_ip}
set allowaccess ping 
set mtu-override enable
set mtu 9001
next
edit port3
set alias MGMT
set mode static
set ip ${fgt_mgmt_ip}
set allowaccess ping https ssh
set mtu-override enable
set mtu 9001
next
end
config router static
edit 1
set device port1
set gateway ${data_gw}
end
config system ha
set group-name fortinet
set group-id 1
set password ${password}
set mode a-p
set hbdev port2 50
set session-pickup enable
set ha-mgmt-status enable
config ha-mgmt-interface
edit 1
set interface port3
set gateway ${mgmt_gw}
next
end
set override disable
set priority ${fgt_priority}
set unicast-hb enable
set unicast-hb-peerip ${fgt-remote-heartbeat}
end
config system vdom-exception
edit 1
set object system.interface
next
edit 2
set object router.static
next
edit 3
set object firewall.vip
next
end

%{ if type == "byol" }
--==AWS==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="license"

${file(license_file)}

%{ endif }
--==AWS==--
