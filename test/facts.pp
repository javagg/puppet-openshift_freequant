notice("public interfaces: $::public_interfaces")
notice("public ipaddress: $::public_ipaddress")
notice("private interfaces: $::private_interfaces")
notice("private ipaddress: $::private_ipaddress")
notice("a interface: $::interface")
$ipp = inline_template("<%= @ipaddress_$::interface %>")
#notice('a ip: inline_template("<%= @ipaddress_$iface %>"))
notice("a ip: $ipp")
