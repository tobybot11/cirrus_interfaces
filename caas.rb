require 'rubygems'
require 'rest_client'
require 'json'

####----------------------------------------------------------------------------------------------------
####----------------------------------------------------------------------------------------------------
class CaaSResult
  def initialize(session, attributes)
    @session, @attributes = session, attributes
  end
  def method_messing(meth, *args, &blk)
    @attributes.send(meth, *args, &blk)
  end
end


####----------------------------------------------------------------------------------------------------
####----------------------------------------------------------------------------------------------------
class CaaS

  ####--------------------------------------------------------------------------------------------------
  @site = 'https://compute.synaptic.att.com/CirrusServices/resources'

  class << self

    attr_reader :site

    def user(uid, password)
      ses = new
      ses.login(uid, password)
      ses.get_user_ancestors; ses
    end

    def admin(uid, password)
      ses = new
      ses.login(uid, password); ses
    end

  end

  ####--------------------------------------------------------------------------------------------------
  attr_reader :auth, :user_ancestors

  ####---- session
  def login(uid, passwd)
    @auth = json_to_hash(post(:url          => '/login',
                              :body         => {:user_id=>uid,:password=>passwd},
                              :accept       => cloud_type_with_common('Login'),
                              :content_type => cloud_type('Login'),
                              :no_auth      => true))
  end

  def logout
    post(:url    => '/logout',
         :accept => cloud_type('common.Messages'))
  end

  ####---- accounts
  def create_account(args)
    json_to_hash(post(:url          => '/accounts',
                      :body         => args,
                      :accept       => cloud_type('common.Messages'),
                      :content_type => cloud_type('Account')))
  end

  def get_account(args)
    json_to_hash(get(:url    => args[:uri],
                     :accept => cloud_type_with_common('Account')))
  end

  def get_all_accounts
    get_all(:account)
  end

  def list_accounts(args={})
    begin
      json_to_hash(get(:url    => "/accounts",
                       :accept => cloud_type_with_common('Account')))
    rescue
     {}
    end
  end

  ####----
  def update_account(args)
    put(:url          => args.delete(:account)[:uri],
        :body         => args,
        :accept       => cloud_type_with_common('Account'),
        :content_type => cloud_type('Account'))
  end

  def delete_account(args)
    put(:url          => args.delete(:account)[:uri],
        :accept       => cloud_type('common.Messages'))
  end

  def onboard(args)
    json_to_hash(post(:url          => "#{args.delete(:account)[:uri]}/onboard",
                      :body         => args,
                      :accept       => cloud_type('common.Messages'),
                      :content_type => cloud_type('Onboard')))
  end

  ####---- clouds
  def get_cloud(args)
    json_to_hash(get(:url    => args[:uri],
                     :accept => cloud_type_with_common('Cloud')))
  end

  def get_all_clouds
    get_all(:cloud)
  end

  def list_clouds(args={})
    begin
      json_to_hash(get(:url    => auth[:clouds_uri],
                       :accept => cloud_type_with_common('Cloud')))
    rescue
      {}
    end
  end

  ####---- vdc
  def get_vdc(args)
    json_to_hash(get(:url    => args[:uri],
                     :accept => cloud_type_with_common('VDC')))
  end

  def get_all_vdcs(args)
    get_all(:vdc, args)
  end

  def list_vdcs
    json_to_hash(get(:url    => "#{args[:parent][:uri]}/vdcs",
                     :accept => cloud_type_with_common('VDC')))
  end

  ####---- cluster
  def get_cluster(args)
    json_to_hash(get(:url    => args[:uri],
                     :accept => cloud_type_with_common('Cluster')))
  end

  def get_all_clusters(args)
    get_all(:cluster, args)
  end

  def list_clusters(args)
    json_to_hash(get(:url    => "#{args[:parent][:uri]}/clusters",
                     :accept => cloud_type_with_common('Cluster')))
  end

  ####---- vnet
  def get_vnet(args)
    json_to_hash(get(:url    => args[:uri],
                     :accept => cloud_type_with_common('Vnet')))
  end

  def get_all_vnets(args)
    get_all(:vnet, args)
  end

  def list_vnets(args)
    json_to_hash(get(:url    => "#{args[:parent][:uri]}/vnets",
                     :accept => cloud_type_with_common('Vnet')))
  end

  ####---- volume
  def get_volume(args)
    json_to_hash(get(:url    => "#{args[:parent][:uri]}/volumes/#{args[:id]}",
                     :accept => cloud_type_with_common('Volume')))
  end

  def get_all_volumes(args)
    get_all(:volume, args)
  end

  def list_volumes(args)
    json_to_hash(get(:url    => "#{args[:parent][:uri]}/volumes",
                     :accept => cloud_type_with_common('Volume')))
  end

  ####---- vms
  def create_vm(args)
  end

  def get_vm(args)
  end

  def get_all_vms(args)
    get_all(:vm, args)
  end

  def list_vms(args)
  end

  ####----
  def update_vm(args)
  end

  def delete_vm(args)
  end

  def control_vm(args)
  end

  ####---- locations
  def create_location(args)
  end

  def get_location(args)
  end

  def get_all_locations(args)
  end

  def list_locations
    json_to_hash(get(:url    => '/locations',
                     :accept => cloud_type_with_common('Location')))
  end

  ####----
  def update_locations(args)
  end

  def delete_locations(args)
  end

  ####---- vm templates
  def create_vmtemplate(args)
  end

  def get_vmtemplate(args)
  end

  def get_all_vmtemplates(args)
  end

  def list_vmtemplates
    json_to_hash(get(:url    => '/vmtemplates',
                     :accept => cloud_type_with_common('VMTemplate')))
  end

  ####----
  def update_vmtemplate(args)
  end

  def delete_vmtemplate(args)
  end

  ####---- version
  def get_version
    json_to_hash(get(:url     => '/version',
                     :accept  => cloud_type_with_common('Version'),
                     :no_auth => true))
  end

  ####---- utils
  def get_user_ancestors
  end

  def get_all(obj, args={})
    send(('list_'+obj.to_s+'s').to_sym, args).map{|(u,o)| {:uri=>u}}.inject([]) do |l,o|
      begin
        l << send(('get_'+obj), o)
      rescue
        l
      end
    end
  end

  def json_to_hash(json)
    symbolize_keys(JSON.parse(json))
  end

  def to_json(hash)
    hash.to_json.gsub(/\\\//,'/')
  end

  def cloud_type_with_common(type)
    cloud_type(type) + ',' + cloud_type('common.Messages')
  end

  def cloud_type(type)
    "application/vnd.com.sun.cloud.#{type}+json"
  end

  def symbolize_keys(hash)
    hash.inject({}){|r,(k,v)| r.update(k.to_sym=>(v.kind_of?(Hash) ? symbolize_keys(v) : v))}
  end

  def post(args)
    body = args[:body] || {}
    headers = (args[:headers] || {}).update(:accept=>args[:accept],
                                            :x_cloud_specification_version=>'0.1')
    headers.update(:content_type=>args[:content_type]) unless args[:content_type].nil?
    headers.update(:authentication=>'BASIC '+auth[:authentication]) unless args[:no_auth]
    RestClient.post CaaS.site+args[:url], to_json(body), headers
  end

  def get(args)
    headers = (args[:headers] || {}).update(:accept=>args[:accept],
                                            :x_cloud_specification_version=>'0.1')
    headers.update(:authentication=>'BASIC '+auth[:authentication]) unless args[:no_auth]
    RestClient.get CaaS.site+args[:url], headers
  end

  def delete(args)
    headers = (args[:headers] || {}).update(:accept=>args[:accept],
                                            :x_cloud_specification_version=>'0.1',
                                            :authentication=>'BASIC '+auth[:authentication])
    RestClient.delete CaaS.site+args[:url], headers
  end

  def put(args)
    body = args[:body] || {}
    headers = (args[:headers] || {}).update(:accept=>args[:accept],
                                            :x_cloud_specification_version=>'0.1',
                                            :authentication=>'BASIC '+auth[:authentication])
    headers.update(:content_type=>args[:content_type]) unless args[:content_type].nil?
    RestClient.put CaaS.site+args[:url], to_json(body), headers
  end


end
