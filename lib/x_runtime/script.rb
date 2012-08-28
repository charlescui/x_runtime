module XRuntime
  class Script
    attr_accessor :redis
    
    def initialize(redis)
      @redis = redis
      @scripts = {}
      @sha = {}
      
      load
      sha
    end
    
    def load
      Dir[::File.join(::File.dirname(__FILE__), 'lua', '*.lua')].each do |lua|
        act = /(\w*)\.lua/.match(File.basename(lua))[1]
        @scripts[act.to_sym] = IO.read(lua) if act
      end
    end
    
    def sha
      # 加载脚本 redis-server会将该脚本缓存起来
      if @sha.empty?
        @scripts.each do |key, content|
          @sha[key] ||= @redis.script(:load, content)
        end
      end
      
    end
    
    def evalsha(operate, keys, argv)
      @redis.evalsha(@sha[operate], :keys => keys, :argv => argv)
    end
    
  end
end