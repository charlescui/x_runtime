module XRuntime
  class Middleware
    # threshold => ms
    def initialize(app, threshold, redis, &auth)
      @app = app
      @threshold = threshold.to_f
      @redis = redis
      @portal = Portal.new(ds)
      @portal = Rack::Auth::Basic.new(@portal, &auth) if block_given?
    end
    
    def ds
      @ds ||= DataSet.new(redis_key, script)
    end
    
    def script
      @script ||= Script.new(@redis)
    end

    def call(env)
      if env['REQUEST_PATH'] == "/xruntime"
        call_portal(env)
      else
        call_app(env)
      end
    end
  
    def call_app(env)
      start_time = Time.now
      status, headers, body = @app.call(env)
      request_time = (Time.now - start_time).to_f*1000

      if request_time >= @threshold
        logredis(request_time, env['REQUEST_URI']) rescue nil
      end
    
      [status, headers, body]
    end
  
    def call_portal(env)
      @portal.call(env)
    end
    
    def logredis(cost,uri)
      ds.add(uri, cost)
    end
  
    def redis_key
      @key ||= "#{XRuntime::NameSpace}::#{@threshold}"
    end
  
  end#end of Middleware
end
