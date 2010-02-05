Given /^a valid "([^\"]*)" user ID and a valid password$/ do |role|
  @credentials = load_credentials(role)
end

Then /^a valid CaaS "([^\"]*)" session can be created with the following attributes$/ do |role, table|
  ses = CaaS.send(role.to_sym, @credentials['uid'], @credentials['password'])
  table.hashes.each do |a|
    ses.auth[a['attribute'].to_sym].should match_pattern(a['value'])
  end
end
