local path = ARGV[1];
local key = KEYS[1]
local key_counter = string.format("%s::Counter",key)
local key_amount = string.format("%s::Amount",key)
local key_average = string.format("%s::Average",key)

-- 删除最新一次请求的耗时
redis.call('zrem',key,path)
-- 删除某个path的请求次数
redis.call('hdel',key_counter,path)
-- 删除某个path的请求总时长
redis.call('hdel',key_amount,path)
-- 删除某个path的平均时长
redis.call('zrem',key_average,path)
