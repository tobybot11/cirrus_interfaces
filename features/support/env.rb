$:.unshift(File.join(Dir.pwd,'lib'))
require 'rubygems'
require 'cirrus_interfaces'
require 'shoulda'
require 'matchy'

####------------------------------------------------------------------------------------------------------
require 'test/unit/assertions'
World(Test::Unit::Assertions)

####------------------------------------------------------------------------------------------------------
module CaasHelpers

  def load_credentials(role)
    File.open(File.join(Dir.pwd, 'features/support/credentials.yml')) {|yf| YAML::load(yf)}[role]
  end

end

World(CaasHelpers)

####------------------------------------------------------------------------------------------------------
def_matcher :match_pattern do |receiver, matcher, args|
  matcher.positive_msg = "Expected patern match between #{receiver} and '#{args.first}'"
  matcher.negative_msg = "Expected no patern match between #{receiver} and '#{args.first}'"
  unless args.first.eql?('*')
    pat = args.first.gsub('*','')
    url = receiver.gsub(/\d*/,'')
    pat.eql?(url)
  else;true;end
end
