$:.unshift(File.expand_path(File.dirname(__FILE__)))

require "dependencies/dep"

Dep.new(File.read(Dep.dependencies_file)).require(ENV["RACK_ENV"].to_s)

