module XRuntime
  class Portal
    def initialize(ds)
      @ds = ds
    end
    
    def call(env)
      @req = Rack::Request.new(env)
      [200, {}, [Template.new(@ds, :limit => (@req.params["limit"] ? @req.params["limit"].to_i : 20), :offset => @req.params["offset"].to_i).render]]
    end
  end
end