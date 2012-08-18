# encoding: utf-8

require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rake'

require 'jeweler'
Jeweler::Tasks.new do |gem|
  # gem is a Gem::Specification... see http://docs.rubygems.org/read/chapter/20 for more options
  gem.name = "x_runtime"
  gem.homepage = "http://github.com/charlescui/x_runtime"
  gem.license = "MIT"
  gem.summary = %Q{XRuntime是一个Rack的middleware,配合Redis用来分析Http Server每个URI请求时长}
  gem.description = %Q{由于使用到Redis的lua script,所以需要你的Redis服务支持,redis-server版本>2.6.x,redis(ruby gem)>3.0.1.}
  gem.email = "zheng.cuizh@gmail.com"
  gem.authors = ["崔峥"]
  # dependencies defined in Gemfile
end
Jeweler::RubygemsDotOrgTasks.new

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
end

task :default => :test

require 'rdoc/task'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "x_runtime #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
