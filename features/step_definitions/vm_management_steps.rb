####---- common
Then /^it should be possible to delete the Virtual Machine$/ do
  vm.delete
  vms_with_names_matching(/^#{params[:name]}/).should be_empty?
end

Given /^a Virtual Machine started with attributes$/ do |table|
  @vm = create_vm_from_table_data(table)
  vm.run_state.should be('STARTTED')
  ping?(vm).should be_true
end

Given /^the following attributes after creation$/ do |table|
  validate_object(table, vm)
end

Then /^it should be possible to log into the Virtual Machine through its network interface on its "([^\"]*)"$/ do |iface|
  vm_up?(vm.interfaces.first[iface.to_sym]).should be_true
end

Then /^it should not be possible to log into the Virtual Machine through its network interface on its "([^\"]*)"$/ do |iface|
  vm_down?(vm.interfaces.first[iface.to_sym]).should be_true
end

Then /^it should be possible to ping the Virtual Machine through its network interface on its "([^\"]*)"$/ do |iface|
  ping?(vm.interfaces.first[iface.to_sym]).should be_true
end

Given /^and then shutdown with the following attributes$/ do |table|
  @vm = vm.stop
  validate_object(table, vm)
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
  @vm = vm.stop
  validate_object(table, vm)
end

Then /^there should be one available controller$/ do |table|
  vm.controllers.length.should be(1)
  validate_object(table, vm.controllers)
end

####---- restart
Then /^if it is restarted it will have the following run_state$/ do |table|
  @vm = vm.start
  validate_object(table, vm)
end

####---- reboot
Given /^a Virtual Machine that has been verified running and is in run_state STARTED with attributes$/ do |table|
  # table is a Cucumber::Ast::Table
  pending # express the regexp above with the code you wish you had
end

Then /^if it is rebooted it will have the following run_state$/ do |table|
  # table is a Cucumber::Ast::Table
  pending # express the regexp above with the code you wish you had
end

####---- start each template
Given /^the following Virtual Machine configuration$/ do |table|
  # table is a Cucumber::Ast::Table
  pending # express the regexp above with the code you wish you had
end

Then /^create a "([^\"]*)" Virtual Machine$/ do |arg1|
  pending # express the regexp above with the code you wish you had
end

Then /^it should have the following attributes$/ do |table|
  validate_object(table, vm)
end
