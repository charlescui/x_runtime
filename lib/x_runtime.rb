require "pp"
require "rack"
require "redis"
require "digest"
require "fileutils"

require_relative "x_runtime/array"

$:.unshift(File.dirname(__FILE__))

module XRuntime
  NameSpace = "RuntimeEx::Threshold"
  
  autoload :Middleware, "x_runtime/middleware"
  autoload :DataSet,    "x_runtime/data_set"
  autoload :Script,     "x_runtime/script"
  autoload :Portal,     "x_runtime/portal"
  autoload :Template,   "x_runtime/template"
  autoload :Utils,      "x_runtime/utils"
end

module Rack
  XRuntime = XRuntime::Middleware
end