module XRuntime
  class Middleware
    attr_accessor :auth, :redis
    # threshold => ms
    def initialize(app, redis, opts = {})
      @app = app
      @redis = redis
      opts = {:threshold => 100.0, :cache => 50, :expire => 120}.update opts
      @cache = opts[:cache].to_i
      @expire = opts[:expire].to_i
      @threshold = opts[:threshold].to_f
      XRuntime.middleware = self
    end
    
    def ds
      @ds ||= DataSet.new(redis_key, script, @cache, @expire)
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
        logredis(request_time, env['REQUEST_PATH']) rescue nil
      end
    
      [status, headers, body]
    end
    
    def logredis(cost,uri)
      ds.add(uri, cost)
    end
  
  end#end of Middleware
end
