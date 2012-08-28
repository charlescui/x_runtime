module XRuntime
  class DataSet
    attr_accessor :data
    
    def initialize(key, script, count, expire)
      raise ArgumentError, "Script must not nil and be valid!" unless script
      @key = key
      @key_counter = "#{@key}::Counter"
      @key_amount = "#{@key}::Amount"
      @key_average = "#{@key}::Average"
      @script = script
      @count = count
      @expire = expire
      @expired_at = Time.now.to_i
      @data = []
    end
    
    # {key => {:score => score, :count => count, :average => average}}
    def latest(opts = {})
      opts.delete_if{|k,v| v == nil}
      opts = {:limit => 100, :offset => 0}.update(opts)
      data = {}
      key_average = @script.redis
      .zrevrangebyscore(@key_average, '+inf', '-inf', :limit => [opts[:offset], opts[:limit]], :withscores => true)
      .inject({}){|hash, array|hash[array[0]] = array[1]; hash}

      if key_average.size > 0
        key_count = {}
        keys = key_average.keys
        @script.redis.hmget(@key_counter, *key_average.keys).each_with_index{|count, idx| key_count[keys[idx]] = count}

        key_average.keys.each do |key|
          data[key] = {
            :latest => @script.redis.zscore(@key, key),
            :count => key_count[key],
            :average => key_average[key]
          }
        end
      end
      data
    end
    
    def size
      @script.redis.zcard(@key)
    end
    
    def add(member, score)
      @data.push([member, score])
      # 如果@data数据达到一定数量，则一起插入redis
      # 如果上一次写入Redis和这次请求相差时间大于@expire，则在本次请求时也将缓存数据写入Redis
      if (@data.size >= @count) or (Time.now.to_i - @expired_at >= @expire)
        @expired_at = Time.now.to_i
        @script.redis.multi do
          while (data = @data.pop) do
            @script.evalsha(:add, [@key], [data[0], data[1]])
          end
        end
      end
    end
    
    def del(member)
      @script.evalsha(:del, [@key], [member])
    end
    
  end#end of DataSet
end