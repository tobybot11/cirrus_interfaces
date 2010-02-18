Given /^an onboard user session$/ do
  cred = load_credentials('user')
  @user = CaaS.user(cred['uid'], cred['password'])
end

####---- cloud
Then /^a cloud object shall exist with the following attributes$/ do |table|
  validate_object(table, user.cloud)
end

Then /^one vdc with URI$/ do |table|
  table.hashes.each do |a|
    user.cloud.vdcs[a['value'].to_sym].should have_value(a['attribute'])
  end
end

####---- vdc
Then /^a vdc object shall exist with the following attributes$/ do |table|
  validate_object(table, user.vdc)
end

Then /^the root_cluster shall have URI$/ do |table|
  validate_object(table, user.vdc.root_cluster)
end

Then /^there will be one volume with URI$/ do |table|
  user.vdc.volumes.length.should == 1
  validate_object(table, user.vdc.volumes.first)
end

####---- cluster
Then /^a cluster object shall exist with the following attributes$/ do |table|
  # table is a Cucumber::Ast::Table
  pending # express the regexp above with the code you wish you had
end

Then /^two controllers with URIs$/ do |table|
  # table is a Cucumber::Ast::Table
  pending # express the regexp above with the code you wish you had
end

Then /^two vnets with URIs$/ do |table|
  # table is a Cucumber::Ast::Table
  pending # express the regexp above with the code you wish you had
end

Then /^a volume object shall exist with the following attributes$/ do |table|
  # table is a Cucumber::Ast::Table
  pending # express the regexp above with the code you wish you had
end

Then /^two vnets shall exist$/ do
  pending # express the regexp above with the code you wish you had
end

Then /^the first vnet shall have the following attributes$/ do |table|
  # table is a Cucumber::Ast::Table
  pending # express the regexp above with the code you wish you had
end

Then /^the second vnet shall have the following attributes$/ do |table|
  # table is a Cucumber::Ast::Table
  pending # express the regexp above with the code you wish you had
end
