Then /^one location shall be available$/ do
  user.get_all_locations.length.should == 1
end

Then /^one of the locations shall be named "([^\"]*)" and have the following attributes$/ do |name, table|
  validate_object(table, user.get_all_locations.first)
end
