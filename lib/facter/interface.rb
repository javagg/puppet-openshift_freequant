Facter.add("interface") do
  setcode do
    ret = nil
    ifs = Facter.value('public_interfaces')
    ret = ifs.split(',').first unless ifs.nil?
    if ret.nil?
      ifs = Facter.value('private_interfaces')
      ret = ifs.split(',').first unless ifs.nil?
    end
    ret.nil? ? 'lo' : ret
  end
end
