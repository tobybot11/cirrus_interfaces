Given /^an onboard user session$/ do
  cred = load_credentials('user')
  @user = CaaS.user(cred['uid'], cred['password'])
end

Then /^a cloud object shall exist with the following attributes$/ do |table|
end

Then /^a vdc object shall exist with the following attributes$/ do |table|
end

Then /^a cluster object shall exist with the following attributes$/ do |table|
end
