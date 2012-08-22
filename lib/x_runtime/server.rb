require "sinatra/base"

if defined? Encoding
  Encoding.default_external = Encoding::UTF_8
end

module XRuntime
  class Server < Sinatra::Base    
    get '/' do
      @req = Rack::Request.new(env)
      Template.new(XRuntime.middleware.ds, :limit => (@req.params["limit"] ? @req.params["limit"].to_i : 20), :offset => @req.params["offset"].to_i).render
    end
  end
end
