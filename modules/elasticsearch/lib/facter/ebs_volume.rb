require 'facter'
if FileTest.exists?("/dev/xvdf1")
  Facter.add("ebs_volume") { setcode { True } }
end
