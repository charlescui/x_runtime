module XRuntime
  class Profiler
    def initialize(redis, opts = {})
      @redis = redis
      opts = {:cache => 100, :expire => 120}.update opts
      @cache = opts[:cache].to_i
      @expire = opts[:expire].to_i
    end
    
    def ds
      @ds ||= DataSet.new(redis_key, script, @cache, @expire)
    end
    
    def script
      @script ||= Script.new(@redis)
    end
  
    def redis_key
      @key ||= "#{XRuntime::NameSpace}::Profiler"
    end
  
    def call(&blk)
      start_time = Time.now
      result = yield
      cost = (Time.now - start_time).to_f*1000
      
      return cost, result
    end
    
    def logredis(key, &blk)
      raise ArgumentError, "Need a block of code for profile." unless blk
      cost, result = call(&blk)
      ds.add(key, cost)
      return result
    end
    
    alias :log :logredis
    
  end
end