module XRuntime
  class Middleware
    # threshold => ms
    def initialize(app, threshold, redis)
      @app = app
      @threshold = threshold.to_f
      @redis = redis
    end
    
    def ds
      @@ds ||= DataSet.new(redis_key, script)
    end
    
    def script
      @@script ||= Script.new(@redis)
    end

    def call(env)
      status, headers, body = nil
    
      if env['REQUEST_PATH'] == "/xruntime"
        status, headers, body = call_portal(env)
      else
        status, headers, body = call_app(env)
      end

      [status, headers, body]
    end
  
    def call_app(env)
      start_time = Time.now
      status, headers, body = @app.call(env)
      request_time = (Time.now - start_time).to_f*1000

      if request_time >= @threshold
        logredis(request_time, env['REQUEST_URI'])
      end
    
      [status, headers, body]
    end
  
    def call_portal(env)
      @req = Rack::Request.new(env)
      [200, {}, [Template.new(ds, :limit => (@req.params["limit"] ? @req.params["limit"].to_i : 20), :offset => @req.params["offset"].to_i).render]]
    end
    
    def logredis(cost,uri)
      ds.add(uri, cost)
    end
  
    def redis_key
      @key ||= "#{XRuntime::NameSpace}::#{@threshold}"
    end
  
  end#end of Middleware
end
