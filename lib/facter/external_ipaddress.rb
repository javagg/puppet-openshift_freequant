Facter.add("external_ipaddress") do
  setcode do
    ipaddress = Facter.value('ipaddress')
    eip = case ipaddress
      when /^192\.168(\.[0-9]{1,3}){2}$/ : ""
      when /^10(\.[0-9]{1,3}){3}$/ : ""
      when /^172(\.[0-9]{1,3}){3}$/ : ""
      else ipaddress
    end
    eip
  end
end
