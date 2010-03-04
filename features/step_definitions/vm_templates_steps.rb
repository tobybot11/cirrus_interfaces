Then /^a total of 6 Virtual machine Templates shall be available$/ do
  user.get_all_vmtemplates.length.should  be(6)
end

Then /^one of the templates shall be named "([^\"]*)" and have the following attributes$/ do |name, table|
  validate_object(table, user.get_all_vmtemplates.select{|t| t.name.eql?(name)}.first)
end


