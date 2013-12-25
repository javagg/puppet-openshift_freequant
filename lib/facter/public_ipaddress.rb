Facter.add("public_ipaddress") do
  setcode do
    ret = nil
    ifaces = Facter.value("public_interfaces")
    if ifaces.nil?
      ret = nil
    else 
      ifaces = ifaces.split(',')
      ret = Facter.value("ipaddress_#{ifaces.first}")
    end
    ret
  end
end
