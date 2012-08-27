require "sinatra/base"

if defined? Encoding
  Encoding.default_external = Encoding::UTF_8
end

module XRuntime
  class Server < Sinatra::Base    
    
    before do
      halt("Need use Rack::XRuntime first") unless XRuntime.middleware
    end
    
    get '/' do
      @req = Rack::Request.new(env)
      Template.new(XRuntime.m.ds, :limit => (@req.params["limit"] ? @req.params["limit"].to_i : 20), :offset => @req.params["offset"].to_i).render
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
    
    get '/profiler' do
      @req = Rack::Request.new(env)
      Template.new(XRuntime.p.ds, :limit => (@req.params["limit"] ? @req.params["limit"].to_i : 20), :offset => @req.params["offset"].to_i).render
    end
    
  end#end of server
end
