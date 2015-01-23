def check_usb(usb_id)
    res = Facter::Core::Execution.exec("lsusb -d #{usb_id}")
    # puts "Checking USB for #{usb_id} returns #{res.inspect} match #{/#{usb_id}/.match(res)}"
    return true if res != nil and /#{usb_id}/.match(res) != nil
    false
end
Facter.add(:has_us_robotics_usb_modem) do
  confine :kernel => 'Linux'
  setcode do
    usb_id = '0baf:0303'
    check_usb(usb_id)
  end
end

Facter.add(:has_trendnet_usb_modem) do
  confine :kernel => 'Linux'
  setcode do
    usb_id = '0572:1329'
    check_usb(usb_id)
  end
end
