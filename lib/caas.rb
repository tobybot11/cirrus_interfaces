require 'rubygems'
require 'rest_client'
require 'json'

####----------------------------------------------------------------------------------------------------
####----------------------------------------------------------------------------------------------------
class CaaSObject
  @children = {:account=>[], :location=>[], :vmtemplate=>[], :cloud=>[:vdc], :vdc=>[:cluster, :volume],
               :cluster=>[:vm, :vnet]}
  @obj_meths = [:update, :delete, :onboard, :reload]
  class << self ;attr_reader :children, :obj_meths; end

  attr_reader :ses, :attr

  def initialize(ses, attr)
    @ses, @attr = ses, attr
  end

  def method_missing(meth, *args, &blk)
    if attr.include?(meth)
      attr[meth]
    elsif is_child_meth?(meth)
      if /^get_all/.match(meth.to_s)
        ses.send(meth, (args.first || {}).merge(:parent=>self))
      elsif /^get/.match(meth.to_s)
        ses.send(meth, args.first)
      else
        ses.send(meth, (args.first || {}).merge(:parent=>self))
      end
    elsif self.class.obj_meths.include?(meth) and not obj_type.eql?(:unknown)
      ses.send("#{meth}_#{obj_type}".to_sym, self, *args)
    elsif has_controller? and controls.include?(meth)
      ses.send("control_#{obj_type}".to_sym, self, meth, *args)
    else
      attr.send(meth, *args, &blk)
    end
  end

  def merge!(obj)
    if obj.kind_of?(Hash)
      attr.merge!(obj)
    else
      attr.merge!(obj.attr)
    end; self
  end

  def to_hash; attr; end
  def attributes; attr.keys; end

  def has_controller?; not attr[:controllers].nil?; end
  def controls; attr[:controllers].keys;  end

  def obj_type
    if attr[:uri]
      /.*\/(.*)\/\d*$/.match(attr[:uri]).captures.first.gsub(/s$/,'')
    else; :unknown; end
  end

  def is_child_meth?(child_meth)
    if self.class.children[obj_type.to_sym]
      self.class.children[obj_type.to_sym].include?(child_meth.to_s.split('_').last.gsub(/s$/,'').to_sym)
    else; false; end
  end

  private :obj_type, :is_child_meth?, :has_controller?, :controls

end


####----------------------------------------------------------------------------------------------------
####----------------------------------------------------------------------------------------------------
class CaaS

  ####--------------------------------------------------------------------------------------------------
  @site = 'https://compute.synaptic.att.com/CirrusServices/resources'
  MAX_RETRIES = 120

  class << self

    attr_reader :site

    def user(uid, password)
      ses = new
      ses.login(uid, password)
      ses.get_user_objects; ses
    end

    def admin(uid, password)
      ses = new
      ses.login(uid, password); ses
    end

  end

  ####--------------------------------------------------------------------------------------------------
  attr_reader :auth, :user_objects

  def initialize
    @user_objects = {}
  end

  ####---- session
  def login(uid, passwd)
    @auth = json_to_hash(post(:uri          => '/login',
                              :body         => {:user_id=>uid,:password=>passwd},
                              :accept       => cloud_type('Login'),
                              :content_type => cloud_type('Login'),
                              :no_auth      => true))
  end

  def logout
    post(:uri    => '/logout',
         :accept => cloud_type('common.Messages'))
  end

  ####---- accounts
  def create_account(args)
     res = post(:uri          => '/accounts',
                :body         => args,
                :accept       => cloud_type('common.Messages'),
                :content_type => cloud_type('Account'))
    retry_until_found{get_account(res.headers[:location].gsub(CaaS.site,''))}
 end

  def get_account(uri)
    acct = json_to_hash(get(:uri    => uri,
                            :accept => cloud_type('Account')))
    to_caas_object(acct.update(:uri=>acct.delete(:account_uri)))
   end

  def get_all_accounts
    get_all(:account)
  end

  def list_accounts(args={})
    begin
      json_to_hash(get(:uri    => "/accounts",
                       :accept => cloud_type('Account')))
    rescue
     {}
    end
  end

  ####----
  def update_account(acct, *args)
    uacct = to_caas_object(json_to_hash(put(:uri          => acct[:uri],
                                            :body         => acct.merge!(*args),
                                            :accept       => cloud_type('Account'),
                                            :content_type => cloud_type('Account'))))
    acct.merge!(uacct)
  end

  def delete_account(acct, *args)
    acct.reload
    delete(:uri          => acct[:uri],
           :accept       => cloud_type('common.Messages'))
    acct
  end

  def onboard_account(acct, *args)
    json_to_hash(post(:uri          => "#{acct[:uri]}/onboard",
                      :body         => {:location_uri=> "#{args.first[:location][:uri]}",
                                        :vmtemplates_uri => '/vmtemplates'},
                      :accept       => cloud_type('common.Messages'),
                      :content_type => cloud_type('Onboard')))
  end

  def reload_account(acct, *args)
    acct.merge!(get_account(acct.uri))
  end

  ####---- clouds
  def get_cloud(uri)
    cloud = json_to_hash(get(:uri    => uri,
                             :accept => cloud_type('Cloud')))
    to_caas_object(cloud.update(:uri=>cloud.delete(:cloud_uri)))
  end

  def get_all_clouds
    get_all(:cloud)
  end

  def list_clouds(args={})
    begin
      json_to_hash(get(:uri    => auth[:clouds_uri],
                       :accept => cloud_type('Cloud')))
    rescue
      {}
    end
  end

  def cloud
    user_objects[:cloud]
  end

  ####---- vdc
  def get_vdc(uri)
    to_caas_object(json_to_hash(get(:uri    => uri,
                                    :accept => cloud_type('VDC'))))
  end

  def get_all_vdcs(args)
    get_all(:vdc, args)
  end

  def list_vdcs(args)
    json_to_hash(get(:uri    => "#{args[:parent].uri}/vdcs",
                     :accept => cloud_type('VDC')))
  end

  def vdc
    user_objects[:vdc]
  end

  ####---- cluster
  def get_cluster(uri)
     to_caas_object(json_to_hash(get(:uri    => uri,
                                     :accept => cloud_type('Cluster'))))
  end

  def get_all_clusters(args)
    get_all(:cluster, args)
  end

  def list_clusters(args)
    json_to_hash(get(:uri    => "#{args[:parent].uri}/clusters",
                     :accept => cloud_type('Cluster')))
  end

  def cluster
    user_objects[:cluster]
  end

  ####----
  def control_cluster(clus, control, *args)
    post(:uri          => clus.controllers[control],
         :body         => args.first,
         :accept       => cloud_type('common.Messages'),
         :content_type => cloud_type('Cluster'))
    reload_cluster(clus, *args)
  end

  def reload_cluster(clus, *args)
    clus.merge!(get_cluster(clus.uri))
  end

  ####---- vnet
  def get_vnet(uri)
    to_caas_object(json_to_hash(get(:uri    => uri,
                                    :accept => cloud_type('Vnet'))))
  end

  def get_all_vnets(args)
    get_all(:vnet, args)
  end

  def list_vnets(args)
    json_to_hash(get(:uri    => "#{args[:parent].uri}/vnets",
                     :accept => cloud_type('Vnet')))
  end

  def vnets
    user_objects[:cluster].vnets
  end

  ####---- volume
  def get_volume(uri)
    to_caas_object(json_to_hash(get(:uri    => uri,
                                    :accept => cloud_type('Volume'))))
  end

  def get_all_volumes(args)
    get_all(:volume, args)
  end

  def list_volumes(args)
    json_to_hash(get(:uri    => "#{args[:parent].uri}/volumes",
                     :accept => cloud_type('Volume')))
  end

  def volume
    user_objects[:vdc].get_all_volumes.first
  end

  ####---- vms
  def create_vm(args)
    unless args[:parent].nil?
      validate([:name, :vmtemplate, :vnets, :parent], args)
      args[:vmtemplate_uri] = if args[:vmtemplate].kind_of?(String)
                                vmtemplate(args.delete(:vmtemplate)).uri
                              else
                                args.delete(:vmtemplate).uri
                              end
      res = post(:uri          => "#{args.delete(:parent).uri}/vms",
                 :body         => args,
                 :accept       => cloud_type('common.Messages'),
                 :content_type => cloud_type('Vm'))
      retry_until_found{get_vm(res.headers[:location].gsub(CaaS.site,''))}
    else
      create_vm(args.merge({:parent=>user_objects[:cluster], :vnets=>vnets.map{|v| v.uri}}))
    end
  end

  def get_vm(uri)
    to_caas_object(json_to_hash(get(:uri    => uri,
                                    :accept => cloud_type('Vm'))))
  end

  def get_all_vms(args={})
    get_all(:vm, args)
  end

  def list_vms(args={})
    unless args[:parent].nil?
      json_to_hash(get(:uri    => "#{args[:parent].uri}/vms",
                       :accept => cloud_type('Vm')))
    else
      list_vms(:parent=>user_objects[:cluster])
    end
  end

  ####----
  def update_vm(vm, *args)
    uvm = to_caas_object(json_to_hash(put(:uri          => vm[:uri],
                                          :body         => acct.merge!(*args),
                                          :accept       => cloud_type('Account'),
                                          :content_type => cloud_type('Account'))))
    vm.merge!(uvm)
  end

  def delete_vm(vm, *args)
    vm.reload
    delete(:uri          => vm[:uri],
           :accept       => cloud_type('common.Messages'))
    vm
  end

  def control_vm(vm, control, *args)
    post(:uri          => vm.controllers[control],
         :body         => args.first,
         :accept       => cloud_type('common.Messages'),
         :content_type => cloud_type('Vm'))
    reload_vm(vm, *args)
  end

  def reload_vm(vm, *args)
    vm.merge!(get_vm(vm.uri))
  end

  ####---- locations
  def create_location(args)
  end

  def get_location(uri)
    to_caas_object(json_to_hash(get(:uri    => uri,
                                    :accept => cloud_type('Location'))))
  end

  def get_all_locations
    get_all(:location)
  end

  def list_locations(args={})
    json_to_hash(get(:uri    => '/locations',
                     :accept => cloud_type('Location')))
  end

  ####----
  def update_locations(args)
  end

  def delete_locations(args)
  end

  ####---- vm templates
  def create_vmtemplate(args)
  end

  def get_vmtemplate(uri)
    to_caas_object(json_to_hash(get(:uri    => uri,
                                    :accept => cloud_type('VMTemplate'))))
  end

  def get_all_vmtemplates
    get_all(:vmtemplate)
  end

  def list_vmtemplates(args={})
    json_to_hash(get(:uri    => '/vmtemplates',
                     :accept => cloud_type('VMTemplate')))
  end

  def vmtemplate(name)
    tmp = get_all_vmtemplates.select{|t| t.name.eql?(name)}
    tmp.empty? ? (raise ArgumentError, "#{name} is invalid vmtemplate name")  : tmp.first
  end

  ####----
  def update_vmtemplate(args)
  end

  def delete_vmtemplate(args)
  end

  ####---- version
  def get_version
    ver = json_to_hash(get(:uri     => '/version',
                           :accept  => cloud_type('Version'),
                           :no_auth => true))
    CaaSObject.new(self, ver)
  end

  ####---- utils
  def get_user_objects
    @user_objects = {}
    @user_objects[:cloud] = get_all_clouds.first
    @user_objects[:vdc] = user_objects[:cloud].get_all_vdcs.first
    @user_objects[:cluster] = user_objects[:vdc].get_all_clusters.first
  end

  def validate(expect, given)
    given_args = given.keys
    expect.each{|e| (raise ArgumentError, "#{e} missing") unless given_args.include?(e)}
  end

  def to_caas_object(obj)
    if obj.kind_of?(Hash) and obj[:uri]
      obj.inject(CaaSObject.new(self,{})){|r,(k,v)| r.merge!({k=>to_caas_object(v)})}
    elsif obj.kind_of?(Array)
      obj.map{|o| to_caas_object(o)}
    else; obj; end
  end

  def get_all(obj, args={})
    send(('list_'+obj.to_s+'s').to_sym, args).map{|(u,o)| u.to_s}.inject([]) do |l,o|
      begin
        l << send(('get_'+obj), o)
      rescue
        l
      end
    end
  end

  def json_to_hash(json)
    json.empty? ? nil : symbolize_keys(JSON.parse(json))
  end

  def to_json(hash)
    hash.to_json.gsub(/\\\//,'/')
  end

  def cloud_type(type)
    "application/vnd.com.sun.cloud.#{type}+json"
  end

  def symbolize_keys(obj)
    if obj.kind_of?(Hash)
      obj.inject({}){|r,(k,v)| r.update(k.to_sym=>symbolize_keys(v))}
    elsif obj.kind_of?(Array)
      obj.map{|o| symbolize_keys(o)}
    else; obj; end
  end

  def retry_until_found
    try_count = 0
    begin
      try_count += 1
      yield
    rescue RestClient::ResourceNotFound
      sleep(1)
      try_count < CaaS::MAX_RETRIES ? retry : raise
    end
  end

  def post(args)
    body = args[:body] || {}
    headers = (args[:headers] || {}).update(:accept=>args[:accept],
                                            :x_cloud_specification_version=>'0.1')
    headers.update(:content_type=>args[:content_type]) unless args[:content_type].nil?
    headers.update(:authentication=>'BASIC '+auth[:authentication]) unless args[:no_auth]
    RestClient.post CaaS.site+args[:uri], to_json(body), headers
  end

  def get(args)
    headers = (args[:headers] || {}).update(:accept=>args[:accept],
                                            :x_cloud_specification_version=>'0.1')
    headers.update(:authentication=>'BASIC '+auth[:authentication]) unless args[:no_auth]
    RestClient.get CaaS.site+args[:uri], headers
  end

  def delete(args)
    headers = (args[:headers] || {}).update(:accept=>args[:accept],
                                            :x_cloud_specification_version=>'0.1',
                                            :authentication=>'BASIC '+auth[:authentication])
    RestClient.delete CaaS.site+args[:uri], headers
  end

  def put(args)
    body = args[:body] || {}
    headers = (args[:headers] || {}).update(:accept=>args[:accept],
                                            :x_cloud_specification_version=>'0.1',
                                            :authentication=>'BASIC '+auth[:authentication])
    headers.update(:content_type=>args[:content_type]) unless args[:content_type].nil?
    RestClient.put CaaS.site+args[:uri], to_json(body), headers
  end


end
