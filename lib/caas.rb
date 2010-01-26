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
    json_to_hash(post(:uri          => '/accounts',
                      :body         => args,
                      :accept       => cloud_type('common.Messages'),
                      :content_type => cloud_type('Account')))
  end

  def get_account(args)
    json_to_hash(get(:uri    => args[:uri],
                     :accept => cloud_type('Account')))
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
  def update_account(args)
    put(:uri          => args.delete(:account)[:account_uri],
        :body         => args,
        :accept       => cloud_type('Account'),
        :content_type => cloud_type('Account'))
  end

  def delete_account(args)
    delete(:uri          => args.delete(:account)[:account_uri],
           :accept       => cloud_type('common.Messages'))
  end

  def onboard(args)
    vmtemplates_uri = args[:vmtemplates][:vmtemplates_uri] || '/vmtemplates'
    json_to_hash(post(:uri          => "#{args[:account][:account_uri]}/onboard",
                      :body         => {:location_uri=> "#{args[:location][:location_uri]}/",
                                        :vmtemplates_uri => vmtemplates_uri},
                      :accept       => cloud_type('common.Messages'),
                      :content_type => cloud_type('Onboard')))
  end

  ####---- clouds
  def get_cloud(args)
    json_to_hash(get(:uri    => args[:uri],
                     :accept => cloud_type('Cloud')))
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

  ####---- vdc
  def get_vdc(args)
    json_to_hash(get(:uri    => args[:uri],
                     :accept => cloud_type('VDC')))
  end

  def get_all_vdcs(args)
    get_all(:vdc, args)
  end

  def list_vdcs
    json_to_hash(get(:uri    => "#{args[:parent][:cloud_uri]}/vdcs",
                     :accept => cloud_type('VDC')))
  end

  ####---- cluster
  def get_cluster(args)
    json_to_hash(get(:uri    => args[:uri],
                     :accept => cloud_type('Cluster')))
  end

  def get_all_clusters(args)
    get_all(:cluster, args)
  end

  def list_clusters(args)
    json_to_hash(get(:uri    => "#{args[:parent][:vdc_uri]}/clusters",
                     :accept => cloud_type('Cluster')))
  end

  ####---- vnet
  def get_vnet(args)
    json_to_hash(get(:uri    => args[:uri],
                     :accept => cloud_type('Vnet')))
  end

  def get_all_vnets(args)
    get_all(:vnet, args)
  end

  def list_vnets(args)
    json_to_hash(get(:uri    => "#{args[:parent][:cluster_uri]}/vnets",
                     :accept => cloud_type('Vnet')))
  end

  ####---- volume
  def get_volume(args)
    json_to_hash(get(:uri    => "#{args[:parent][:uri]}/volumes/#{args[:vdc_id]}",
                     :accept => cloud_type('Volume')))
  end

  def get_all_volumes(args)
    get_all(:volume, args)
  end

  def list_volumes(args)
    json_to_hash(get(:uri    => "#{args[:parent][:uri]}/volumes",
                     :accept => cloud_type('Volume')))
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
    json_to_hash(get(:uri    => args[:uri],
                     :accept => cloud_type('Location')))
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

  def get_vmtemplate(args)
    json_to_hash(get(:uri    => args[:uri],
                     :accept => cloud_type('VMTemplate')))
  end

  def get_all_vmtemplates
    get_all(:vmtemplate)
  end

  def list_vmtemplates(args={})
    json_to_hash(get(:uri    => '/vmtemplates',
                     :accept => cloud_type('VMTemplate')))
  end

  ####----
  def update_vmtemplate(args)
  end

  def delete_vmtemplate(args)
  end

  ####---- version
  def get_version
    json_to_hash(get(:uri     => '/version',
                     :accept  => cloud_type('Version'),
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
    json.empty? ? nil : symbolize_keys(JSON.parse(json))
  end

  def to_json(hash)
    hash.to_json.gsub(/\\\//,'/')
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
