####---- common
Given /^a Virtual Machine started with attributes$/ do |table|
  @vm = create_vm_from_table_data(table)
  vm.run_state.should be('STARTED')
  ping?(vm.interfaces.first[:public_address]).should be_true
end

Given /^the following attributes after creation$/ do |table|
  validate_object(table, vm)
end

Then /^it should be possible to log into the Virtual Machine through its network interface on its "([^\"]*)"$/ do |iface|
  if iface.eql?('ip_address')
    vm_up?(vm.interfaces.first[iface.to_sym]).should be_true if test_private_ip?
  else
    vm_up?(vm.interfaces.first[iface.to_sym]).should be_true
  end
end

Then /^it should not be possible to log into the Virtual Machine through its network interface on its "([^\"]*)"$/ do |iface|
  if iface.eql?('ip_address')
    vm_down?(vm.interfaces.first[iface.to_sym]).should be_true if test_private_ip?
  else
    vm_down?(vm.interfaces.first[iface.to_sym]).should be_true
  end
end

Then /^it should be possible to ping the Virtual Machine through its network interface on its "([^\"]*)"$/ do |iface|
  if iface.eql?('ip_address')
    ping?(vm.interfaces.first[iface.to_sym]).should be_true if test_private_ip?
  else
    ping?(vm.interfaces.first[iface.to_sym]).should be_true
  end
end

Given /^and then shutdown with the following attributes$/ do |table|
  @vm = vm.stop
  validate_object(table, vm)
end

Then /^it should be possible to delete the Virtual Machine$/ do
  vm.delete
  vm_with_uri_matching(vm.uri).should be_nil
end

####---- create/delete virtual machine
Given /^the following Virtual Machine Configuration$/ do |table|
  create_vm_from_table_data(table)
end

Then /^create a Virtual Machine which shall have the following attributes$/ do |table|
  validate_object(table, vm)
end

Then /^three controllers with the following URIs$/ do |table|
  vm.controllers.length.should be(3)
  validate_object(table, vm.controllers)
end

Then /^the following interface attributes$/ do |table|
  validate_object(table, vm.interfaces.first)
end

####---- shutdown
Then /^when the Virtual Machine is sutdown it will have the following attributes$/ do |table|
  retry_until_state(vm.stop, 'STOPPED').should be_true
  validate_object(table, vm)
end

Then /^there should be one available controller$/ do |table|
  vm.controllers.length.should be(1)
  validate_object(table, vm.controllers)
end

####---- restart
Then /^if it is restarted it will have the following run_state$/ do |table|
  retry_until_state(vm.start, 'STARTED').should be_true
  validate_object(table, vm)
end

####---- reboot
Then /^if it is rebooted it will have the following run_state$/ do |table|
  retry_until_state(vm.reboot, 'STARTED').should be_true
  validate_object(table, vm)
end

####---- start each template
Given /^the following Virtual Machine configuration$/ do |table|
  @params =  vm_create_attributes(table)
end

Then /^create a "([^\"]*)" Virtual Machine$/ do |arg1|
  create_vm_from_table_data_params
end

Then /^it should have the following attributes$/ do |table|
  validate_object(table, vm)
end

Then /^it should be possible to mount a Volume and write a file to the volume$/ do
  mount_volume(vm.interfaces.first[:public_address])
  volume_available?(vm.interfaces.first[:public_address]).should be_true
end
