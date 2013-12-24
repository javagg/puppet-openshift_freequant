Facter.add("public_ipaddress") do
  setcode do
    ifaces = Facter.value("public_interfaces").split(',')
    Facter.value("ipaddress_#{ifaces.first}")
  end
end
