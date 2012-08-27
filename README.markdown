# x_runtime

XRuntime是一个Rack的middleware,配合Redis用来分析Http Server每个URI请求时长.    
由于使用到Redis的**lua script**,所以需要你的Redis服务支持.

版本要求:
* redis-server版本>2.6.x
* redis(ruby gem)>3.0.1

在Redis中，对每一个REQUEST_PATH记录了以下信息:
* 请求总数
* 总共请求时间
* 最近一次请求时间
* 平均请求时间

当请求积累到50次后，通过pipeline机制一次将数据插入Redis,避免每次请求都访问一下Redis.   
引入了缓存超时机制后，当上一次将缓存写入时间和最新一次请求时间查过expire秒后，则将缓存写入Redis.

## Portal

可以访问Http Server的这个URL来实时查看当前记录的请求:[/xruntime](/xruntime)    
这个页面是按照每个REQUEST_PATH数次执行后的平均时间来排序的。

## Usage

引入这个middleware需要的参数:

1. redis对象
2. :threshold,表示处理时间超过多少毫秒的请求才会被记录,默认100毫秒
3. :cache,表示请求积累到多少条的时候才通过redis的pipeline机制插入到redis数据库中,默认50
4. :expire,如果上一次写入Redis和这次请求相差时间大于expire，则在本次请求时也将缓存数据写入Redis,默认120秒

可以指定XRuntime使用的Redis的key前缀或者叫命名空间:    
`XRuntime::NameSpace = "XRuntime::Threshold"`  

### Middleware

#### Server

可以通过自带的Http页面查看请求数据，这些页面可以设置Http basic auth验证以保护起来	 

``` ruby
XRuntime::Server.use(Rack::Auth::Basic) do |user, password|
  user == 'cui' && password == "hello"
end
```

增加一个子页面`/incache`,可以查看缓存中没有插入Redis的数据，但要记得这些缓存数据是在每个Server各自的进程中保存，每次访问这个页面，得到的缓存数据只代表该进程正在缓存的数据。

#### Sinatra

收集数据 `config.ru`:  

``` ruby
use Rack::XRuntime, Redis.connect(:url => "redis://localhost:6379/"), :threshold => 100.0, :cache => 50
```

查看数据 `config.ru`:  

``` ruby
run Rack::URLMap.new \
  "/"       => Server.new,
  "/xruntime" => XRuntime::Server.new
```

#### Rails3

收集数据 `config/environment.rb`:   

``` ruby
config.middleware.use Rack::XRuntime, Redis.connect(:url => "redis://localhost:6380/"), :threshold => 100.0, :cache => 50
```

查看数据 `config/routes.rb`:   

``` ruby
mount XRuntime::Server, :at => "/xruntime"
```

### Profiler

这个功能用来将web server中一段代码的执行时间记录下来以供分析    

需要传递两个参数   

* 一个作为这块代码的标示:key
* 另外一个是proc代码片段

调用时使用:`XRuntime.profiler.log(key){...}`或者简写`XRuntime.p.log(key){...}`    

返回值是代码块的返回值，不影响原有逻辑。

#### Server

通过这个地址可以查看运行结果:`\profiler`

#### Rails3 && Sinatra

``` ruby
XRuntime.p.log("/index") do
  sleep(0.01*rand(10))
  "Hello, I'am x_runtime"
end
```

### Test

请先修改test/server.rb和test/client.rb中的Redis参数,我的地址是localhost:6380,这个请改为你的地址。

* 先启动服务 `rackup test/server.ru`
* 再产生测试数据 `ruby test/client.rb`
	
执行完毕后可以打开浏览器访问[/xruntime](http://localhost:4567/xruntime),看是否已经准确的记录了一些数据

## Redis Lua Script

redis-server的版本要大于2.6.0才会支持lua script,    
可以使用__script__系列命令来测试服务端是否支持

启动__redis-cli__

    redis 127.0.0.1:6380> SCRIPT LOAD "local key = KEYS[1];local path = tonumber(ARGV[1]);redis.call('set',key, path)"
    "dab89791b5a512390f69e1f59eb1753f671b6649"
    redis 127.0.0.1:6380> evalsha dab89791b5a512390f69e1f59eb1753f671b6649 1 hahaha 123456789
    redis 127.0.0.1:6380> get hahaha
    "123456789"

## Contributing to x_runtime
 
* Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet.
* Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it.
* Fork the project.
* Start a feature/bugfix branch.
* Commit and push until you are happy with your contribution.
* Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
* Please try not to mess with the Rakefile, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so I can cherry-pick around it.

## Copyright

Copyright (c) 2012 崔峥. See LICENSE.txt for
further details.

