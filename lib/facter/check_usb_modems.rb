def check_usb(usb_id)
    res = Facter::Core::Execution.exec("lsusb -d #{usb_id}")
    # puts "Checking2 USB for #{usb_id} returns #{res.inspect} match #{/#{usb_id}/.match(res)}"
    entries = Dir.glob('/dev/ttyA*')
    entries.each do
      |entry|
      cmd = "udevadm info -a -n #{entry} | grep #{usb_id.split(':')[1]}"
      # puts "entry #{entry}. Runing cmd #{cmd}"
      detail = Facter::Core::Execution.exec(cmd)
      m = /#{usb_id.split(':')[1]}/.match(detail)
      return entry if detail and m
    end
    false
end

Facter.add(:has_us_robotics_usb_modem) do
  confine :kernel => 'Linux'
  setcode do
    check_usb( '0baf:0303')
  end
end

Facter.add(:has_trendnet_usb_modem) do
  confine :kernel => 'Linux'
  setcode do
    usb_id =
    check_usb('0572:1329')
  end
end
