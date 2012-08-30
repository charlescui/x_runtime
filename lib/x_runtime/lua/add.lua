local path = ARGV[1];
local score = tonumber(ARGV[2])
local key = KEYS[1]
local key_counter = key.."::Counter"
local key_amount = key.."::Amount"
local key_average = key.."::Average"

-- 记录最新一次请求的耗时
redis.call('zadd',key,score,path)
-- 记录某个path的请求次数
redis.call('hincrby',key_counter,path,1)
-- 记录某个path的请求总时长
redis.call('hincrbyfloat',key_amount,path,score)
-- 记录某个path的平均时长
local average = tonumber(redis.call('hget',key_amount,path))/tonumber(redis.call('hget',key_counter,path))
redis.call('zadd',key_average,average,path)
return average