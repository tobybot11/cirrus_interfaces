$:.unshift(File.join(Dir.pwd,'lib'))
require 'rubygems'
require 'net/ssh'
require 'cirrus_interfaces'
require 'shoulda'
require 'matchy'

####------------------------------------------------------------------------------------------------------
require 'test/unit/assertions'
World(Test::Unit::Assertions)

####------------------------------------------------------------------------------------------------------
module CaasHelpers

   MAX_RETRIES = 20

  def load_credentials(type)
    File.open(File.join(Dir.pwd, 'features/support/credentials.yml')) {|yf| YAML::load(yf)}[type]
  end

  def user; @user; end
  def admin; @admin; end

  def cmd(vm, cmd)
    cred, result = load_credentails('vm'), ''
    Net::SSH.start(vm.interfaces.first[:public_address],cred['uid'],:password=>cred['password']) do |ssh|
      result = ssh.exec!(cmd)
    end; result
  end

  def vm_up?(vm)
    cmd(vm, 'id -nu').eql?(load_credentails('vm')['uid'])
  end

  def mount_volume(vm, vol)
    cmd(vm, "mount #{vol.webdav.gsub(/nfs:\/\//,'')} /data")
  end

  def volume_available?(vm, vol)
    file = "/data/test_file-#{Time.now.to_s.gsub(/ |:/,'-')}"
    cmd(vm, "touch #{file}")
    result = cmd(vm, "ls ")
    cmd(vm, "rm -f #{file}")
    result.eql?(file)
  end

  def retry_cmd
    try_count = 0
    begin
      try_count += 1
      yield
    rescue Errno::ETIMEDOUT
      sleep(60)
      try_count < MAX_RETRIES ? retry : raise
    end
  end

end

World(CaasHelpers)

####------------------------------------------------------------------------------------------------------
def_matcher :have_value do |receiver, matcher, args|
  matcher.positive_msg = "Expected match between #{receiver} and '#{args.first}'"
  matcher.negative_msg = "Expected no match between #{receiver} and '#{args.first}'"
  if /^user|^admin/.match(args.first)
    receiver.eql?(eval(args.first))
  elsif args.first.eql?('*')
    true
  elsif args.first.include?('*')
    args.first.gsub('*','').eql?(receiver.gsub(/\d*/,''))
  else
    args.first.eql?(receiver)
  end
end
