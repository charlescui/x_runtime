local path = ARGV[1];
local key = KEYS[1]
local key_counter = key.."::Counter"
local key_amount = key.."::Amount"
local key_average = key.."::Average"

-- 删除最新一次请求的耗时
redis.call('zrem',key,path)
-- 删除某个path的请求次数
redis.call('hdel',key_counter,path)
-- 删除某个path的请求总时长
redis.call('hdel',key_amount,path)
-- 删除某个path的平均时长
redis.call('zrem',key_average,path)
