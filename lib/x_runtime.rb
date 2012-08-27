require "pp"
require "rack"
require "redis"
require "digest"
require "fileutils"

$:.unshift(File.dirname(__FILE__))

module XRuntime
  NameSpace     = "XRuntime::Threshold"
  extend        self
  
  def middleware
    @middleware || raise(RuntimeError, "XRuntime::Middleware haven't been used as a middleware.")
  end
  
  def middleware=(m)
    @middleware = m
  end
  
  def profiler
    @profiler ||= Profiler.new(middleware.redis, :cache => 200, :expire => 120)
  end
  
  alias :p :profiler
  alias :m :middleware
  
  autoload :Middleware, "x_runtime/middleware"
  autoload :DataSet,    "x_runtime/data_set"
  autoload :Script,     "x_runtime/script"
  autoload :Server,     "x_runtime/server"
  autoload :Template,   "x_runtime/template"
  autoload :Utils,      "x_runtime/utils"
  autoload :Profiler,    "x_runtime/profiler"
end

module Rack
  XRuntime = XRuntime::Middleware
end