$:.unshift(File.join(Dir.pwd,'lib'))
require 'rubygems'
require 'cirrus_interfaces'
require 'shoulda'
require 'matchy'

####------------------------------------------------------------------------------------------------------
module CaasHelpers

  def load_credentials(role)
    File.open(File.join(Dir.pwd, 'features/support/credentials.yml')) {|yf| YAML::load(yf)}[role]
  end

end

World(CaasHelpers)

####------------------------------------------------------------------------------------------------------
def_matcher :match_pattern do |receiver, matcher, args|
  true
end
