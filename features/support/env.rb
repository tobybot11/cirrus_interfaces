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

  def user; @user; end
  def admin; @admin; end

end

World(CaasHelpers)

####------------------------------------------------------------------------------------------------------
def_matcher :have_value do |receiver, matcher, args|
  matcher.positive_msg = "Expected match between #{receiver} and '#{args.first}'"
  matcher.negative_msg = "Expected no match between #{receiver} and '#{args.first}'"
  if /^user|^admin/.match(args.first)
    receiver.eql?(eval(args.first))
  elsif args.first.eql('*')
    true
  elsif args.first.inlude?('*')
    args.first.gsub('*','').eql?(receiver.gsub(/\d*/,''))
  else
    args.first.eql?(receiver)
  end
end
