if FileTest.exists?("/dev/xvdf1")
  Facter.add("ebs_volume") { setcode { '/dev/xvdf1' } }
end
