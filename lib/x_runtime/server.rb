require "erb"
require "sinatra/base"

if defined? Encoding
  Encoding.default_external = Encoding::UTF_8
end

module XRuntime
  class Server < Sinatra::Base    
  
    dir = File.dirname(File.expand_path(__FILE__))
    
    set :views,  "#{dir}/server/views"
    if respond_to? :public_folder
      set :public_folder, "#{dir}/server/public"
    else
      set :public, "#{dir}/server/public"
    end
    set :static, true
    
    before do
      halt("Need use Rack::XRuntime first") unless XRuntime.middleware
    end
    
    helpers do
      include Rack::Utils
      
      alias_method :h, :escape_html

      def current_section
        url_path request.path_info.sub('/','').split('/')[0].downcase
      end

      def current_page
        url_path request.path_info.sub('/','')
      end

      def url_path(*path_parts)
        [ path_prefix, path_parts ].join("/").squeeze('/')
      end
      alias_method :u, :url_path

      def path_prefix
        request.env['SCRIPT_NAME']
      end
    end
    
    get '/' do
      erb :index
    end
    
    get '/incache' do
      {
        :status => 0, 
        :msg => "data in cache.", 
        :data => {
          :count => XRuntime.middleware.ds.data.size,
          :data => XRuntime.middleware.ds.data
        }
      }.to_json
    end
    
    get '/p' do
      @limit = (params["limit"] ? params["limit"].to_i : 20)
      @offset = [params["offset"].to_i, 0].max
      @data = XRuntime.p.ds.latest(:limit => @limit, :offset => @offset)
      erb :p
    end
    
    get '/p/del' do
      @member = params[:member]
      XRuntime.p.ds.del(@member)
      redirect to("/p")
    end
    
    get '/m' do
      @limit = (params["limit"] ? params["limit"].to_i : 20)
      @offset = [params["offset"].to_i, 0].max
      @data = XRuntime.m.ds.latest(:limit => @limit, :offset => @offset)
      erb :m
    end
    
    get '/m/del' do
      @member = params[:member]
      XRuntime.m.ds.del(@member)
      redirect to("/m")
    end
    
  end#end of server
end
