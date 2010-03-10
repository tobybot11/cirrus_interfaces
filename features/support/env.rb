$:.unshift(File.join(Dir.pwd,'lib'))
require 'rubygems'
require 'net/ping'
require 'net/ssh'
require 'cirrus_interfaces'
require 'shoulda'
require 'matchy'

####------------------------------------------------------------------------------------------------------
require 'test/unit/assertions'
World(Test::Unit::Assertions)

####------------------------------------------------------------------------------------------------------
module CaasHelpers

  attr_reader :user, :admin, :vm, :params

  MAX_RETRIES = 20

  def load_config(type)
    File.open(File.join(Dir.pwd, 'features/support/config.yml')) {|yf| YAML::load(yf)}[type]
  end

  def validate_object(table, obj)
    table.hashes.each do |a|
      obj[(/[0-9]+/.match(attr = a['attribute']) ?  attr.to_i : attr.to_sym)].should have_value(a['value'])
    end
  end

  def vm_create_attributes(table)
    table.hashes.inject({}) do |h,a|
      h.update(a['attribute'].to_sym => a['value'])
    end
  end

  def cmd(iface, cmd)
    cred, result = load_config('vm'), ''
    Net::SSH.start(iface, cred['uid'],:password=>cred['new_password']) do |ssh|
      result = ssh.exec!(cmd)
    end; result
  end

  def vm_up?(iface)
    if ping?(iface)
      cred = load_config('vm')
      res = `features/support/change_password.exp #{iface} '#{cred['password']}' '#{cred['new_password']}'`
      cmd(iface, 'id -nu').chomp.eql?(cred['uid'])
    else; false; end
  end

  def vm_down?(iface)
    begin
      cmd(iface, 'id -nu').eql?(load_config('vm')['uid'])
    rescue Errno::ETIMEDOUT
      true
    else
      false
    end
  end

  def ping?(iface, count=0)
    if count < MAX_RETRIES
      unless Net::Ping::TCP.new(iface, 'http').ping?
        sleep(60)
        ping?(iface, count + 1)
      else; true; end
    else; false; end
  end

  def retry_until_run_state(vm, state, count=0)
    sleep(60)
    if count < MAX_RETRIES
      vm.reload
      unless vm.run_state.eql?(state)
        retry_until_state(vm, state, count + 1)
      else; true; end
    else; false; end
  end

  def test_private_ip?
    load_config('config')['test_private_ip']
  end

  def mount_volume(iface, vol)
    cmd(iface, "mount #{vol.webdav.gsub(/nfs:\/\//,'')} /data")
  end

  def volume_available?(iface, vol)
    file = "/data/test_file-#{Time.now.to_s.gsub(/ |:/,'-')}"
    cmd(iface, "touch #{file}")
    result = cmd(iface, "ls ")
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

  def create_vms(args, count = 1)
    (1..count).map do |c|
      Thread.new do
        user.create_vm(:name=>args[:name]+"-#{c}", :description=>args[:description], :vmtemplate=>args[:vmtemplate])
      end
    end
  end

  def create_vm_from_table_data(table)
    @params =  vm_create_attributes(table)
    @vm = user.create_vm(:name=>params[:name], :description=>params[:description], :vmtemplate=>params[:vmtemplate])
  end

  def create_vm_from_table_data_params
    if (params)
      @vm = user.create_vm(:name=>params[:name], :description=>params[:description], :vmtemplate=>params[:vmtemplate])
    end
  end

  def vm_with_uri_matching(uri)
    user.get_all_vms.select{|v| v.uri.eql?(uri)}.first
  end

end

World(CaasHelpers)

####------------------------------------------------------------------------------------------------------
def_matcher :have_value do |receiver, matcher, args|
  matcher.positive_msg = "Expected '#{args.first}' but got '#{receiver}'"
  matcher.negative_msg = "Expected '#{args.first}' not '#{receiver}'"
  if /^user|^admin/.match(args.first)
    receiver.eql?(eval(args.first))
  elsif /^\[|^\{/.match(args.first)
    receiver.eql?(eval(args.first))
  elsif args.first.eql?('nil')
    receiver.nil?
  elsif args.first.eql?('*')
    if receiver.nil?
      matcher.positive_msg = "Expected not nil"
      matcher.negative_msg = "Expected nil"
      false
    else; true; end
  elsif args.first.include?('*')
    res_path = receiver.split('/')
    exp_path = args.first.split('/')
    exp_path.each_with_index do |v,i|
      if v.eql?('*')
        exp_path[i] = ''
        res_path[i] = ''
      end
    end
    exp_path.join('/').eql?(res_path.join('/'))
  else
    args.first.eql?(receiver.to_s)
  end
end

####---------------------------------------------------------------------------
def_matcher :be do |receiver, matcher, args|
  args.first.eql?(receiver)
end

####---------------------------------------------------------------------------
def_matcher :be_nil do |receiver, matcher, args|
  receiver.nil?
end

####---------------------------------------------------------------------------
def_matcher :be_true do |receiver, matcher, args|
  receiver
end

####---------------------------------------------------------------------------
def_matcher :be_empty do |receiver, matcher, args|
  receiver.empty?
end
