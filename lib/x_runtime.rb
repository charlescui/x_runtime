require "pp"
require "rack"
require "redis"
require "digest"
require "fileutils"

$:.unshift(File.dirname(__FILE__))

module XRuntime
  NameSpace     = "RuntimeEx::Threshold"
  extend        self
  attr_accessor :middleware
  
  autoload :Middleware, "x_runtime/middleware"
  autoload :DataSet,    "x_runtime/data_set"
  autoload :Script,     "x_runtime/script"
  autoload :Server,     "x_runtime/server"
  autoload :Template,   "x_runtime/template"
  autoload :Utils,      "x_runtime/utils"
end

module Rack
  XRuntime = XRuntime::Middleware
end