module XRuntime
  class Script
    attr_accessor :redis
    
    def initialize(redis)
      @redis = redis
    end

    def content
      @script ||= IO.read(::File.join(::File.dirname(__FILE__),'redis.lua'))
    end
    
    def sha
      # 加载脚本 redis-server会将该脚本缓存起来
      @sha ||= @redis.script(:load, content)
    end
    
    def evalsha(keys, argv)
      @redis.evalsha(sha, :keys => keys, :argv => argv)
    end
    
  end
end