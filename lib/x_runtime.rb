require "pp"
require "rack"
require "redis"
require "digest"
require "fileutils"

require_relative "x_runtime/array"

$:.unshift(File.dirname(__FILE__))

module XRuntime
  NameSpace = "RuntimeEx::Threshold"
end

XRuntime.autoload :Middleware, "x_runtime/middleware"
XRuntime.autoload :DataSet,    "x_runtime/data_set"
XRuntime.autoload :Script,     "x_runtime/script"
XRuntime.autoload :Template,   "x_runtime/template"
XRuntime.autoload :Utils,      "x_runtime/utils"

module Rack
  XRuntime = XRuntime::Middleware
end