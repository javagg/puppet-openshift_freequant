def _external?(ip)
  true
end
Facter.add("external_interfaces") do
  setcode do
    ifaces = Facter.value('interfaces')
    ifaces.collect do |iface|
      ip = Facter.value("ipaddress_#{iface}")
      _external?(ip)
    end
    ifaces
  end
end
