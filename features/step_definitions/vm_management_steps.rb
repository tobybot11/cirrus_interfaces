####---- common
Then /^it should be possible to delete the Virtual Machine$/ do
  vm.delete
  vms_with_names_matching(/^#{params[:name]}/).should be_empty?
end

Given /^a Virtual Machine started with attributes$/ do |table|
  # table is a Cucumber::Ast::Table
  pending # express the regexp above with the code you wish you had
end

Given /^the following attributes after creation$/ do |table|
  # table is a Cucumber::Ast::Table
  pending # express the regexp above with the code you wish you had
end

Then /^it should be possible to log into the Virtual Machine through its network interface on its "([^\"]*)"$/ do |arg1|
  pending # express the regexp above with the code you wish you had
end

Then /^it should not be possible to log into the Virtual Machine through its network interface on its "([^\"]*)"$/ do |arg1|
  pending # express the regexp above with the code you wish you had
end

####---- create/delete virtual machine
Given /^the following Virtual Machine Configuration$/ do |table|
  create_vm_from_table_data(table)
end

Then /^create a Virtual Machine which shall have the following attributes$/ do |table|
  validate_object(table, vm)
end

Then /^three controllers with the following URIs$/ do |table|
  validate_object(table, vm.controllers)
end

Then /^the following interface attributes$/ do |table|
  validate_object(table, vm.interfaces.first)
end

####---- shutdown
Then /^when the Virtual Machine is sutdown it will have the following attributes$/ do |table|
  # table is a Cucumber::Ast::Table
  pending # express the regexp above with the code you wish you had
end

Then /^there should be one available controller$/ do |table|
  # table is a Cucumber::Ast::Table
  pending # express the regexp above with the code you wish you had
end

Given /^and shutdown with the folloing attributes$/ do |table|
  # table is a Cucumber::Ast::Table
  pending # express the regexp above with the code you wish you had
end

####---- restart
Then /^if it is restarted it will have the following run_state$/ do |table|
  # table is a Cucumber::Ast::Table
  pending # express the regexp above with the code you wish you had
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

