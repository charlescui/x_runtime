require "sinatra"
require_relative "../lib/x_runtime"

# redis-server version must > 2.6.0 for lua script.
# use XRuntime::Middleware, 10, Redis.connect(:url => "redis://localhost:6380/")
use Rack::XRuntime, 10, Redis.connect(:url => "redis://localhost:6380/")

get /.*/ do
  # sleep(1)
  sleep(0.01*rand(10))
  "Hello, I'am x_runtime"
end