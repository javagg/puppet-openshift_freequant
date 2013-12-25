Facter.add("ipaddress") do
  setcode do
    ip = nil
    ip = Facter.value('public_ipaddress')
    ip = Facter.value('private_ipaddress') if ip.nil?
    ip = '127.0.0.1' if ip.nil?
  end
end
