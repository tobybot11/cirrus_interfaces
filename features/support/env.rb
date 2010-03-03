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

  def cmd(vm, cmd)
    cred, result = load_credentails('vm'), ''
    Net::SSH.start(vm.interfaces.first[:public_address],cred['uid'],:password=>cred['password']) do |ssh|
      result = ssh.exec!(cmd)
    end; result
  end

  def vm_up?(vm)
    cmd(vm, 'id -nu').eql?(load_credentails('vm')['uid'])
  end

  def vm_down?(vm)
    begin
      cmd(vm, 'id -nu').eql?(load_credentails('vm')['uid'])
    rescue Errno::ETIMEDOUT
      true
    else
      false
    end
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

  def create_vms(count, args)
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

  def vms_with_names_matching(reg)
    user.get_all_vms.select{|v| reg.match(v.name)}
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
def_matcher :be_nil do |receiver, matcher, args|
  receiver.nil?
end

####---------------------------------------------------------------------------
def_matcher :be_empty? do |receiver, matcher, args|
  receiver.empty?
end
