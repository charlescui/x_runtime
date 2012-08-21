module XRuntime
  class Middleware
    attr_accessor :auth
    # threshold => ms
    def initialize(app, threshold, redis, &auth)
      @app = app
      @threshold = threshold.to_f
      @redis = redis
      @auth = auth
      XRuntime.middleware = self
    end
    
    def ds
      @ds ||= DataSet.new(redis_key, script)
    end
    
    def script
      @script ||= Script.new(@redis)
    end
  
    def redis_key
      @key ||= "#{XRuntime::NameSpace}::#{@threshold}"
    end
  
    def call(env)
      start_time = Time.now
      status, headers, body = @app.call(env)
      request_time = (Time.now - start_time).to_f*1000

      if request_time >= @threshold
        logredis(request_time, env['REQUEST_URI']) rescue nil
      end
    
      [status, headers, body]
    end
    
    def logredis(cost,uri)
      ds.add(uri, cost)
    end
  
  end#end of Middleware
end
