####---- create/delete virtual machine
Given /^the following Virtual Machine Configuration$/ do |table|
  @params =  vm_create_attributes(table)
  @vm = user.create_vm(:name=>params[:name], :description=>params[:description], :vmtemplate=>params[:vmtemplate])
end

Then /^create a Virtual Machine which shall have the following attributes$/ do |table|
  validate_object(table, vm)
end

Then /^three controllers with the following URIs$/ do |table|
  validate_object(table, vm.controllers)
end

Then /^the following interface attributes$/ do |table|
  validate_object(table, vm.interfaces)
end

Then /^delete the virtual machine$/ do
  vm.delete
  user.get_all_vms.select{|v| v.name.eql?(params[:name])}.should be_empty?
end

####---- stop/restart/reboot virtual machine
Given /^a Virtual Machine that has been verified running and is in run_state STARTED with attributes$/ do |table|
  # table is a Cucumber::Ast::Table
  pending # express the regexp above with the code you wish you had
end

Then /^the Virtual Machine shall have the following attributes with values$/ do |table|
  # table is a Cucumber::Ast::Table
  pending # express the regexp above with the code you wish you had
end

Then /^it should be possible to log into the Virtual Machine through its network interface on its "([^\"]*)"$/ do |arg1|
  pending # express the regexp above with the code you wish you had
end

Then /^there should be one available controller$/ do |table|
  # table is a Cucumber::Ast::Table
  pending # express the regexp above with the code you wish you had
end

Given /^a Virtual Machine that has been verified stopped and is in run_state STOPPED with attributes$/ do |table|
  # table is a Cucumber::Ast::Table
  pending # express the regexp above with the code you wish you had
end

Then /^if it is restarted it will have the following run_state$/ do |table|
  # table is a Cucumber::Ast::Table
  pending # express the regexp above with the code you wish you had
end

Then /^if it is rebooted it will have the following run_state$/ do |table|
  # table is a Cucumber::Ast::Table
  pending # express the regexp above with the code you wish you had
end

Then /^if it is deleted it should not be returned in a query for Virtual Machines$/ do
  pending # express the regexp above with the code you wish you had
end

