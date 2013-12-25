# 10/8, 172.16/12, 192.168/16
def _public?(ip)
  return false if ip.nil?
  return false if /^127\./ =~ ip
  return false if /^10\./ =~ ip
  return false if /^192\.168\./ =~ ip
  return false if /^172\.(1[6-9]|2[0-9]|3[0-1])\./ =~ ip
  true
end

Facter.add("private_interfaces") do
  setcode do
    ifaces = Facter.value('interfaces')
    ifaces = ifaces.split(',') unless ifaces.nil?
    # Remove loopback
    ifaces.delete_if { |e| e == "lo" }
    ifaces = ifaces.select do |iface|
      ip = Facter.value("ipaddress_#{iface}")
      not _public?(ip)
    end
    ifaces.join(",")
  end
end
