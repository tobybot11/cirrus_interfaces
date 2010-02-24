Given /^that the user is not authenticated$/ do
end

Then /^it shall be possible to retrieve the Cirrus API Version object with the following attributes$/ do |table|
  validate_object(table, CaaS.get_version)
end

